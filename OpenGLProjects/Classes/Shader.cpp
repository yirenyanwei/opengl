//
//  Shader.cpp
//  OpenGLProject
//
//  Created by yanwei on 2021/1/17.
//  Copyright © 2021 yanwei. All rights reserved.
//

#include "Shader.hpp"
#include <iostream>
#include <fstream>
#include <sstream>
using namespace std;

Shader::Shader(const char* vertexPath, const char* fragmentPath, const char* geometryPath)
{
    vertexString = getContentFromFile(vertexPath);
    fragmentString = getContentFromFile(fragmentPath);
    
    vertexSource = vertexString.c_str();
    fragmentSource = fragmentString.c_str();
    
    geometrySource = nullptr;
    if(geometryPath!=nullptr) {
        geometryString = getContentFromFile(geometryPath);
        geometrySource = geometryString.c_str();
    }
    
//    printf("vetexSource:\n%s", vertexSource);
//    printf("fragmentSource:\n%s", fragmentSource);
    
    PID = createProgram();
    
}

Shader::~Shader()
{
    
}

string Shader::getContentFromFile(const char* shaderPath)
{
    ifstream vertexFile;
    stringstream vertexSStream;
    //读本地文件
    vertexFile.open(shaderPath);
    vertexFile.exceptions(ifstream::failbit|ifstream::badbit);
    try {
        if(!vertexFile.is_open())
        {
            throw "open file error! ";
        }
        //读入到stringStream中
        vertexSStream<<vertexFile.rdbuf();
        
    } catch (const char* exc) {
        printf("%s--%s", shaderPath, exc);
    }
    return vertexSStream.str();
}

GLint Shader::createShader(GLenum type)
{
    GLuint vertex;
    string error;
    const char* source;
    if(type == GL_VERTEX_SHADER) {
        error = "VERTEX";
        source = vertexSource;
    }else if(type == GL_FRAGMENT_SHADER){
        error = "FRAGMENT";
        source = fragmentSource;
    }else if(type == GL_GEOMETRY_SHADER) {
        error = "GEOMETRY";
        source = geometrySource;
    }
    vertex = glCreateShader(type);//创建着色器
    glShaderSource(vertex, 1, &source, nullptr);//把这个着色器源码附加到着色器对象上
    glCompileShader(vertex);//编译
    
    //检查错误
    checkCompileErrors(vertex, error);
    return vertex;
}

GLint Shader::createProgram()
{
    GLuint vertex = createShader(GL_VERTEX_SHADER);
    GLuint fragment = createShader(GL_FRAGMENT_SHADER);
    GLuint geometry = 0;
    if(geometrySource != nullptr) {
        geometry = createShader(GL_GEOMETRY_SHADER);
    }
    
    //着色器程序对象(Shader Program Object)是多个着色器合并之后并最终链接完成的版本
   //函数创建一个程序，并返回新创建程序对象的ID引用
    GLuint PID = glCreateProgram();
   
    glAttachShader(PID, vertex);//附加
    glAttachShader(PID, fragment);
    if(geometrySource!=nullptr) {
        glAttachShader(PID, geometry);
    }

    glLinkProgram(PID);//链接

    //检查错误
    checkCompileErrors(PID, "PROGRAM");
    //激活这个程序对象
    glUseProgram(PID);
    //记得删除着色器对象
    glDeleteShader(vertex);
    glDeleteShader(fragment);
    if(geometrySource != nullptr)
        glDeleteShader(geometry);
    return PID;
}

void Shader::checkCompileErrors(unsigned int shader, std::string type)
{
    int success;
    char infoLog[1024];
    if (type != "PROGRAM")
    {
        glGetShaderiv(shader, GL_COMPILE_STATUS, &success);
        if (!success)
        {
            glGetShaderInfoLog(shader, 1024, NULL, infoLog);
            std::cout << "ERROR::SHADER_COMPILATION_ERROR of type: " << type << "\n" << infoLog << "\n -- --------------------------------------------------- -- " << std::endl;
        }
    }
    else
    {
        glGetProgramiv(shader, GL_LINK_STATUS, &success);
        if (!success)
        {
            glGetProgramInfoLog(shader, 1024, NULL, infoLog);
            std::cout << "ERROR::PROGRAM_LINKING_ERROR of type: " << type << "\n" << infoLog << "\n -- --------------------------------------------------- -- " << std::endl;
        }
    }
}
