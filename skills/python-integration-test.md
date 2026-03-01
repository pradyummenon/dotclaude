# skill: python integration testing

## framework
pytest + testcontainers-python + httpx

## testcontainers setup

```python
import pytest
from testcontainers.postgres import PostgresContainer

@pytest.fixture(scope="module")
def postgres():
    with PostgresContainer("postgres:16-alpine") as pg:
        yield pg

@pytest.fixture(scope="module")
def db_url(postgres) -> str:
    return postgres.get_connection_url()
```

## fastapi integration test

```python
import pytest
from httpx import AsyncClient, ASGITransport
from app.main import create_app

@pytest.fixture
async def client(db_url: str) -> AsyncGenerator[AsyncClient, None]:
    app = create_app(database_url=db_url)
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as ac:
        yield ac

@pytest.mark.asyncio
async def test_create_patient(client: AsyncClient):
    response = await client.post("/api/v1/patients", json={
        "name": "John Doe",
        "conditions": ["diabetes"],
    })
    assert response.status_code == 201
    data = response.json()
    assert data["name"] == "John Doe"
    assert "id" in data
```

## database fixture with cleanup

```python
@pytest.fixture(autouse=True)
async def clean_db(db_session: AsyncSession):
    yield
    await db_session.execute(text("TRUNCATE TABLE patients CASCADE"))
    await db_session.commit()
```

## external API mocking (respx for httpx)

```python
import respx

@pytest.mark.asyncio
@respx.mock
async def test_should_handle_external_api_failure(client: AsyncClient):
    respx.get("https://external-api.com/labs").mock(
        return_value=httpx.Response(500)
    )
    response = await client.get("/api/v1/patients/123/labs")
    assert response.status_code == 502
```

## what to integrate vs mock
- **integrate**: database (via testcontainers), cache (redis testcontainer), message queue
- **mock**: external third-party APIs (via respx/responses), email, SMS
- **never mock**: your own application code

## assertion patterns
- test full HTTP contract: status code, response body, headers
- verify database state after writes
- check that events were published
- validate error response format

## common pitfalls
- use `scope="module"` for containers (expensive to create)
- use `scope="function"` for database cleanup fixtures
- don't forget `autouse=True` for cleanup fixtures
- always test both success and failure paths
- use `freezegun` or `time-machine` for time-dependent tests
