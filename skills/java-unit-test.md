# skill: java unit testing

## framework
JUnit 5 + Mockito + AssertJ

## setup pattern

```java
@ExtendWith(MockitoExtension.class)
class PatientServiceTest {

    @Mock
    private PatientRepository patientRepository;

    @Mock
    private NotificationService notificationService;

    @InjectMocks
    private PatientService patientService;
}
```

## test structure (arrange-act-assert)

```java
@Test
@DisplayName("should return patient when valid ID provided")
void shouldReturnPatientWhenValidId() {
    // arrange
    var patientId = UUID.randomUUID();
    var expected = Patient.builder().id(patientId).name("John Doe").build();
    when(patientRepository.findById(patientId)).thenReturn(Optional.of(expected));

    // act
    var result = patientService.findById(patientId);

    // assert
    assertThat(result).isPresent();
    assertThat(result.get().getName()).isEqualTo("John Doe");
}
```

## parameterized tests

```java
@ParameterizedTest
@CsvSource({
    "120/80, NORMAL",
    "140/90, ELEVATED",
    "180/120, CRITICAL"
})
@DisplayName("should classify blood pressure correctly")
void shouldClassifyBloodPressure(String reading, String expectedCategory) {
    var result = classifier.classify(BloodPressure.parse(reading));
    assertThat(result.category().name()).isEqualTo(expectedCategory);
}
```

## exception testing

```java
@Test
@DisplayName("should throw when patient not found")
void shouldThrowWhenPatientNotFound() {
    var unknownId = UUID.randomUUID();
    when(patientRepository.findById(unknownId)).thenReturn(Optional.empty());

    assertThatThrownBy(() -> patientService.findById(unknownId))
        .isInstanceOf(PatientNotFoundException.class)
        .hasMessageContaining(unknownId.toString());
}
```

## assertion best practices
- use AssertJ fluent assertions over JUnit assertions
- `assertThat(result).isEqualTo(expected)` not `assertEquals`
- `assertThat(list).hasSize(3).extracting("name").containsExactly("a", "b", "c")`
- use `SoftAssertions` for multiple checks on same object

## mocking strategy
- mock external dependencies (repositories, clients, services)
- never mock the class under test
- prefer `when().thenReturn()` over `doReturn().when()`
- use `verify()` sparingly — test behavior, not that methods were called
- use `@Spy` only when you need partial mocking (rare)

## common pitfalls
- don't test private methods directly — test through public API
- don't over-verify mock interactions
- don't share mutable state between tests
- don't ignore flaky tests — fix the root cause
- use `@Nested` classes to group related test scenarios
