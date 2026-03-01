# skill: java integration testing

## framework
Spring Boot Test + Testcontainers + WireMock

## spring boot test setup

```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@Testcontainers
class PatientApiIntegrationTest {

    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine")
        .withDatabaseName("testdb")
        .withUsername("test")
        .withPassword("test");

    @DynamicPropertySource
    static void configureProperties(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
        registry.add("spring.datasource.username", postgres::getUsername);
        registry.add("spring.datasource.password", postgres::getPassword);
    }

    @Autowired
    private TestRestTemplate restTemplate;
}
```

## test configuration overrides

```java
@TestConfiguration
class TestConfig {

    @Bean
    public NotificationService notificationService() {
        return new NoOpNotificationService(); // stub external service
    }
}
```

## wiremock for external APIs

```java
@WireMockTest(httpPort = 8089)
class ExternalApiIntegrationTest {

    @Test
    void shouldHandleExternalApiTimeout() {
        stubFor(get(urlPathEqualTo("/api/v1/labs"))
            .willReturn(aResponse()
                .withStatus(200)
                .withFixedDelay(5000))); // simulate timeout

        var response = restTemplate.getForEntity("/patients/123/labs", String.class);
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.GATEWAY_TIMEOUT);
    }
}
```

## database test patterns

```java
@Test
@Sql("/test-data/patients.sql") // load test fixtures
void shouldFindPatientsByCondition() {
    var results = patientRepository.findByCondition("diabetes");
    assertThat(results).hasSize(3);
    assertThat(results).allMatch(p -> p.getConditions().contains("diabetes"));
}
```

## assertion patterns
- test the full HTTP contract: status code, headers, body
- verify database state after write operations
- check audit logs / events were published
- validate error response format matches API spec

## what to mock vs what to integrate
- **integrate**: database, message queues, caches (via Testcontainers)
- **mock**: external third-party APIs (via WireMock), email services, SMS gateways
- **never mock**: your own application code in integration tests

## common pitfalls
- don't share database state between tests — use `@Transactional` or truncate
- don't hardcode ports — use `@DynamicPropertySource`
- don't skip cleanup — leaked containers eat CI resources
- use `@TestMethodOrder(MethodOrderer.OrderAnnotation.class)` only when truly sequential
