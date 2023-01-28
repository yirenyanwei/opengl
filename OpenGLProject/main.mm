//
//  main.m
//  OpenGLProject
//
//  Created by yanwei on 2021/1/2.
//  Copyright © 2021 yanwei. All rights reserved.
//
// System Headers
#include "glad/glad.h"
#include <GLFW/glfw3.h>
//图片加载库
#define STB_IMAGE_IMPLEMENTATION
//#include "stb_image.h"

// Standard Headers
#include <cstdio>
#include <cstdlib>
#include <iostream>
#include <random>
#include <math.h>
//glm
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
//self
#include "ResourceManager.hpp"
#include "Game.hpp"

using namespace std;



// The Width of the screen
const unsigned int SCREEN_WIDTH = 800;
// The height of the screen
const unsigned int SCREEN_HEIGHT = 600;



//#pragma mark Input
//鼠标输入
float lastX;
float lastY;
bool firstMouse = true;
void framebuffer_size_callback(GLFWwindow* window, int width, int height);//回调函数原型声明
void key_callback(GLFWwindow* window, int key, int scancode, int action, int mode);
void mouse_callback(GLFWwindow* window, double xpos, double ypos);
//#pragam mark -

Game Breakout(SCREEN_WIDTH, SCREEN_HEIGHT);

int main(int argc, char * argv[]) {
    //取路径
    string exePath = argv[0];
    string rootPath = exePath.substr(0, exePath.find_last_of('/'));
    cout<<"exePath:"<<exePath<<" rootPath:"<<rootPath<<endl;

//#pragam mark window
    //初始化GLFW
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);//版本号
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);//配置使用core
    glfwWindowHint(GLFW_SAMPLES, 4);// 我们希望使用一个包含N个样本的多重采样缓冲
#ifdef __APPLE__
    //向前兼容性
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE); // uncomment this statement to fix compilation on OS X
#endif
    //调试输出 开关
    glfwWindowHint(GLFW_OPENGL_DEBUG_CONTEXT, GL_TRUE);
    //创建一个窗口对象
    GLFWwindow* window = glfwCreateWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "FirstGL", NULL, NULL);
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
    glfwSetKeyCallback(window, key_callback);
    //初始化GLAD用来管理OpenGL的函数指针
    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
    {
        std::cout << "Failed to initialize GLAD" << std::endl;
        return -1;
    }
    //无论我们怎么去移动鼠标，光标都不会显示了，它也不会离开窗口
    glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_DISABLED);
    //鼠标一移动mouse_callback函数就会被调用
    glfwSetCursorPosCallback(window, mouse_callback);
    
    // OpenGL configuration
    // --------------------
    glViewport(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    //背面剔除 //逆时针作为正面
//    glEnable(GL_CULL_FACE);
//    glCullFace(GL_BACK);
    //开启深度测试
//    glEnable(GL_DEPTH_TEST);
//    glDepthFunc(GL_LESS);
//    glStencilFunc(GL_ALWAYS, 1, 0xFF);
//    glStencilOp(GL_KEEP, GL_KEEP, GL_REPLACE); //模板测试、深度测试都通过时将储存的模板值设置为参考值
    // 颜色混合
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    // 调整点大小
//    glEnable(GL_PROGRAM_POINT_SIZE);
    //线框模式
//    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);//测试用的
    // 来启用多重采样
//    glEnable(GL_MULTISAMPLE);
    //开启GL_FRAMEBUFFER_SRGB以后，每次像素着色器运行后续帧缓冲，OpenGL将自动执行gamma校正，包括默认帧缓冲
//    glEnable(GL_FRAMEBUFFER_SRGB);
    
    // initialize game
    // ---------------
    Breakout.Init();
    
    // deltaTime variables
    // -------------------
    float deltaTime = 0.0f;
    float lastFrame = 0.0f;
    //渲染循环
    while(!glfwWindowShouldClose(window))
    {
        // deal time
        float currentFrame = glfwGetTime();
        deltaTime = currentFrame - lastFrame;
        lastFrame = currentFrame;
        glfwPollEvents();//检查触发事件
        
        // manage user input
        // -----------------
        Breakout.ProcessInput(deltaTime);

        // update game state
        // -----------------
        Breakout.Update(deltaTime);

        // render
        // ------
        glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);
        Breakout.Render();
        
        // 检查并调用事件，交换缓冲
        glfwSwapBuffers(window);//交换颜色缓冲
        
    }
    
    // delete all resources as loaded using the resource manager
    // ---------------------------------------------------------
    ResourceManager::Clear();

    //释放/删除之前的分配的所有资源
    glfwTerminate();
    return EXIT_SUCCESS;
}

void key_callback(GLFWwindow* window, int key, int scancode, int action, int mode)
{
    // when a user presses the escape key, we set the WindowShouldClose property to true, closing the application
    if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS)
        glfwSetWindowShouldClose(window, true);
    if (key >= 0 && key < 1024)
    {
        if (action == GLFW_PRESS)
            Breakout.Keys[key] = true;
        else if (action == GLFW_RELEASE)
            Breakout.Keys[key] = false;
    }
}

// 当用户改变窗口的大小的时候，视口也应该被调整
void framebuffer_size_callback(GLFWwindow* window, int width, int height)
{
    // 注意：对于视网膜(Retina)显示屏，width和height都会明显比原输入值更高一点。
    glViewport(0, 0, width, height);
}


void mouse_callback(GLFWwindow* window, double xpos, double ypos)
{
    if(firstMouse) {
        //m避免首次问题
        lastX = xpos;
        lastY = ypos;
        firstMouse = false;
    }
    float deltaX, deltaY;
    deltaX = xpos - lastX;
    deltaY = ypos - lastY;
    
    lastX = xpos;
    lastY = ypos;
//    printf("\n mouse Pos dx = %f, dy = %f", deltaX, deltaY);
}
