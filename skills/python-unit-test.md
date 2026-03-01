# skill: python unit testing

## framework
pytest + pytest-asyncio + pytest-cov

## fixture patterns

```python
@pytest.fixture
def sample_patient() -> Patient:
    return Patient(
        id=uuid4(),
        name="John Doe",
        conditions=["diabetes", "hypertension"],
    )

@pytest.fixture
def mock_repository() -> AsyncMock:
    repo = AsyncMock(spec=PatientRepository)
    repo.find_by_id.return_value = Patient(id=uuid4(), name="Test")
    return repo

@pytest.fixture
def service(mock_repository: PatientRepository) -> PatientService:
    return PatientService(repository=mock_repository)
```

## conftest.py patterns

```python
# tests/conftest.py — shared across all tests
@pytest.fixture
def anyio_backend():
    return "asyncio"

@pytest.fixture
def sample_config(tmp_path: Path) -> Config:
    config_file = tmp_path / "config.toml"
    config_file.write_text('[database]\nurl = "sqlite:///test.db"')
    return Config.from_file(config_file)
```

## parametrized tests

```python
@pytest.mark.parametrize(
    "reading, expected_category",
    [
        ("120/80", BloodPressureCategory.NORMAL),
        ("140/90", BloodPressureCategory.ELEVATED),
        ("180/120", BloodPressureCategory.CRITICAL),
    ],
)
def test_classify_blood_pressure(reading: str, expected_category: BloodPressureCategory):
    result = classifier.classify(BloodPressure.parse(reading))
    assert result.category == expected_category
```

## async test patterns

```python
@pytest.mark.asyncio
async def test_should_extract_entities(service: ExtractionService):
    result = await service.extract("Patient has diabetes and hypertension")
    assert len(result.entities) == 2
    assert result.entities[0].name == "diabetes"
```

## exception testing

```python
def test_should_raise_on_invalid_input(service: PatientService):
    with pytest.raises(ValidationError, match="name cannot be empty"):
        service.create(name="", age=30)
```

## monkeypatch for env vars

```python
def test_config_from_env(monkeypatch):
    monkeypatch.setenv("DATABASE_URL", "postgresql://localhost/test")
    config = Config.from_env()
    assert config.database_url == "postgresql://localhost/test"
```

## mocking strategy
- mock external dependencies (API clients, repositories, file I/O)
- never mock the class under test
- use `AsyncMock(spec=ProtocolClass)` for typed mocks
- use `monkeypatch` over `unittest.mock.patch` for env vars and attributes
- assert mock calls only when the interaction is the behavior being tested

## common pitfalls
- don't use `scope="session"` with async fixtures — causes deadlocks
- don't share mutable state between tests
- don't test internal implementation — test public behavior
- use `tmp_path` for file system tests, never write to real directories
- mark slow tests with `@pytest.mark.slow` and skip in CI fast runs
