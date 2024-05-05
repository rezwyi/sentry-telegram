from functools import cached_property

import pytest
import responses
from sentry.models import Rule
from sentry.plugins.base import Notification
from sentry.testutils.cases import PluginTestCase
from sentry.utils import json
from sentry_telegram.plugin import TelegramPlugin


class BaseTest(PluginTestCase):
    @cached_property
    def plugin(self):
        return TelegramPlugin()

    def test_conf_key(self):
        assert self.plugin.conf_key == "sentry_telegram_py3"

    @responses.activate
    def test_complex_send_notification(self):
        responses.add(
            responses.POST, "https://api.telegram.org/botapi:token/sendMessage"
        )

        event = self.store_event(
            project_id=self.project.id,
            data={
                "message": "Hello world",
                "level": "error",
                "platform": "python",
            },
        )

        rule = Rule.objects.create(project=self.project, label="my rule")
        notification = Notification(event=event, rule=rule)

        self.plugin.set_option("api_origin", "https://api.telegram.org", self.project)
        self.plugin.set_option("receivers", "123", self.project)
        self.plugin.set_option("api_token", "api:token", self.project)
        self.plugin.set_option(
            "message_template",
            "*[Sentry]* {project_name} {tag[level]}: {title}\n{message}\n{url}",
            self.project,
        )

        with self.options({"system.url-prefix": "http://example.com"}):
            self.plugin.notify(notification)

        request = responses.calls[0].request
        print(request)
        print(request.url)
        print(request.body)

        message_text = (
            "*[Sentry]* Bar error: Hello world\n"
            "Hello world\n"
            "http://example.com/organizations/baz/issues/1/"
        )

        assert request.url == "https://api.telegram.org/botapi:token/sendMessage"

        payload = json.loads(request.body)
        assert payload == {
            "text": message_text,
            "parse_mode": "Markdown",
            "chat_id": "123",
        }

    def test_get_empty_receivers_list(self):
        self.plugin.set_option("receivers", "", self.project)
        assert self.plugin.get_receivers(self.project) == []

    def test_get_config(self):
        self.plugin.get_config(self.project)

    def test_is_configured(self):
        self.plugin.set_option("receivers", "123", self.project)
        self.plugin.set_option("api_token", "api:token", self.project)
        assert self.plugin.is_configured(self.project)

    def test_is_not_configured(self):
        assert not self.plugin.is_configured(self.project)
