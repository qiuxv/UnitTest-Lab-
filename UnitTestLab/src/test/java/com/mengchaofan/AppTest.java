package com.mengchaofan;  // 包名必须与业务类一致

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class AppTest {
    @Test
    @DisplayName("测试应用启动逻辑")
    void testApp() {
        assertDoesNotThrow(() -> App.main(new String[]{}));
    }
}