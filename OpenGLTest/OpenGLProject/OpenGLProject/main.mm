//
//  main.m
//  OpenGLProject
//
//  Created by yanwei on 2021/1/2.
//  Copyright © 2021 yanwei. All rights reserved.
//
// System Headers
#include "glad.h"
#include <GLFW/glfw3.h>

// Standard Headers
#include <cstdio>
#include <cstdlib>
#include <iostream>

using namespace std;

void framebuffer_size_callback(GLFWwindow* window, int width, int height);//回调函数原型声明
void processInput(GLFWwindow *window);

void drawColors();
void loadAndUseShader();

// settings
const unsigned int SCR_WIDTH = 800;
const unsigned int SCR_HEIGHT = 600;

int main(int argc, char * argv[]) {

    //初始化GLFW
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);//版本号
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);//配置使用core
#ifdef __APPLE__
    //向前兼容性
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE); // uncomment this statement to fix compilation on OS X
#endif
    //创建一个窗口对象
    GLFWwindow* window = glfwCreateWindow(SCR_WIDTH, SCR_HEIGHT, "FirstGL", NULL, NULL);
    if (window == NULL)
    {
        std::cout << "Failed to create GLFW window" << std::endl;
        glfwTerminate();
        return -1;
    }
    //通知GLFW将我们窗口的上下文设置为当前线程的主上下文
    glfwMakeContextCurrent(window);
    //对窗口注册一个回调函数,每当窗口改变大小，GLFW会调用这个函数并填充相应的参数供你处理
    glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);
    //初始化GLAD用来管理OpenGL的函数指针
    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
    {
        std::cout << "Failed to initialize GLAD" << std::endl;
        return -1;
    }
    //绘制三角形
    float vertices[] = {
        0.5f, -0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        0.0f, 0.5f, 0.0f
    };
    GLuint VAO, VBO;
    
    glGenVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);
    
    glBindVertexArray(VAO);
    
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    glVertexAttribPointer(0,3,GL_FLOAT,GL_FALSE,3*sizeof(float),(void*)0);
    glEnableVertexAttribArray(0);
    
    glBindBuffer(GL_ARRAY_BUFFER,0);
    glBindVertexArray(0);
    
    loadAndUseShader();

    //渲染循环
    while(!glfwWindowShouldClose(window))
    {
        // 输入
        processInput(window);

        // 渲染指令
        glClearColor(0.2f, 0.3f, 0.3f, 1.0f);//清空屏幕所用的颜色
        glClear(GL_COLOR_BUFFER_BIT);//清空x颜色缓冲
        
        glBindVertexArray(VAO);
        glBindBuffer(GL_ARRAY_BUFFER,VBO);
        
        glDrawArrays(GL_TRIANGLES, 0, 3);
        
        glBindBuffer(GL_ARRAY_BUFFER,0);
        glBindVertexArray(0);
        

        // 检查并调用事件，交换缓冲
        glfwSwapBuffers(window);//交换颜色缓冲
        glfwPollEvents();    //检查触发事件
    }

    //释放/删除之前的分配的所有资源
    glfwTerminate();
    return EXIT_SUCCESS;
}

//输入控制，检查用户是否按下了返回键(Esc)
void processInput(GLFWwindow *window)
{
    if(glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
        glfwSetWindowShouldClose(window, true);
}

// 当用户改变窗口的大小的时候，视口也应该被调整
void framebuffer_size_callback(GLFWwindow* window, int width, int height)
{
    // 注意：对于视网膜(Retina)显示屏，width和height都会明显比原输入值更高一点。
    glViewport(0, 0, width, height);
}

void drawColors()
{
    // 渲染指令
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
}

void loadAndUseShader()
{
    const char* vertexCode =
    "#version 330 core\n"
    "layout(location=0) in vec3 aPos;"
    "void main(){"
    "gl_Position=vec4(aPos,1.0);"
    "}";
    const char* fragmentCode =
    "#version 330 core\n"
    "out vec4 FragColor;"
    "void main(){"
    "FragColor=vec4(1.0,0.5,0.0,1.0);"
    "}";
    
    GLuint vertex,fragment;
    vertex = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertex, 1, &vertexCode, nullptr);
    glCompileShader(vertex);
    
    int success;
    char infoLog[512];
    
    glGetShaderiv(vertex,GL_COMPILE_STATUS,&success);
    
    if(!success)
    {
        glGetShaderInfoLog(vertex,512,nullptr,infoLog);
        cout<<"ERROR:VERTEX\n"<<infoLog<<endl;
    }
    
    fragment = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragment, 1, &fragmentCode, nullptr);
    glCompileShader(fragment);
    
    glGetShaderiv(fragment,GL_COMPILE_STATUS,&success);
    
    if(!success)
    {
        glGetShaderInfoLog(fragment,512,nullptr,infoLog);
        cout<<"ERROR:FRAGMENT\n"<<infoLog<<endl;
    }
    
    GLuint PID = glCreateProgram();
    
    glAttachShader(PID, vertex);
    glAttachShader(PID, fragment);
    
    glLinkProgram(PID);
    
    glGetProgramiv(PID, GL_LINK_STATUS,&success);
    
    if(!success)
    {
        glGetProgramInfoLog(PID,512, nullptr,infoLog);
        cout<<"ERROR:PROGRAM\n"<<infoLog<<endl;
    }
    glDeleteShader(vertex);
    glDeleteShader(fragment);
    
    glUseProgram(PID);
}

