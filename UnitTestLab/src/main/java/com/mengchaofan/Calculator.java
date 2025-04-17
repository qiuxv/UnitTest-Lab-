package com.mengchaofan;  // 包名必须与测试类路径一致

public class Calculator {
    /**
     * 加法运算（处理基本类型）
     */
    public int add(int a, int b) {
        return a + b;
    }

    /**
     * 加法运算（处理对象参数，支持异常测试）
     * @throws IllegalArgumentException 如果参数不合法
     */
    public int add(Object a, Object b) {
        if (a == null || b == null) {
            throw new IllegalArgumentException("参数不能为null");
        }
        if (!(a instanceof Integer) || !(b instanceof Integer)) {
            throw new IllegalArgumentException("参数必须为整数");
        }
        return (Integer) a + (Integer) b;
    }
}