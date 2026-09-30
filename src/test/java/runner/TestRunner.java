package runner;

import com.intuit.karate.junit5.Karate;

class TestRunner {

    @Karate.Test
    Karate runAllFeatures() {
        return Karate.run("classpath:features")
                .outputCucumberJson(true);
    }
}
