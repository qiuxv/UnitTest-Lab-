package com.mengchaofan;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class AppTest {

    @Test
    void testMainMethod() {
        // 这里只做示例，假设App.main()能正常运行
        // 一般main方法测试不建议直接断言
        String[] args = {};
        App.main(args);
        // 如果有返回值或输出，可以进一步断言
        // 这里只保证main能正常执行，不抛异常
        assertTrue(true);
    }
}
