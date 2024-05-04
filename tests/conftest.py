import pytest

pytest_plugins = [
    "sentry.testutils.pytest",
]


@pytest.fixture(autouse=True)
def setup_simulate_on_commit(request):
    from sentry.testutils.hybrid_cloud import simulate_on_commit

    with simulate_on_commit(request):
        yield
