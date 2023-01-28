//
//  Shader.hpp
//  OpenGLProject
//
//  Created by yanwei on 2021/1/17.
//  Copyright © 2021 yanwei. All rights reserved.
//

#ifndef Shader_hpp
#define Shader_hpp

#include <stdio.h>
#include <string>
#include "glad/glad.h"
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
using namespace std;
class Shader
{
public:
    Shader(const char* vertexPath, const char* fragmentPath, const char* geometryPath = nullptr);
    ~Shader();
    //读文件
    string getContentFromFile(const char* shaderPath);
    //创建shader
    GLint createShader(GLenum type);
    //创建Program
    GLint createProgram();
    //检查编译错误
    void checkCompileErrors(unsigned int shader, std::string type);
    
    void use()
    {
        glUseProgram(PID);
    }
    void setBool(const std::string &name, bool value) const
    {
        glUniform1i(glGetUniformLocation(PID, name.c_str()), (int)value);
    }
    // ------------------------------------------------------------------------
    void setInt(const std::string &name, int value) const
    {
        glUniform1i(glGetUniformLocation(PID, name.c_str()), value);
    }
    // ------------------------------------------------------------------------
    void setFloat(const std::string &name, float value) const
    {
        glUniform1f(glGetUniformLocation(PID, name.c_str()), value);
    }
    // ------------------------------------------------------------------------
    void set4Float(const string &name, float values[4]) const
    {
        glUniform4f(glGetUniformLocation(PID, name.c_str()), values[0], values[1], values[2], values[3]);
    }
    void set3Float(const string &name, float values[3])const
    {
        glUniform3f(glGetUniformLocation(PID, name.c_str()), values[0], values[1], values[2]);
    }
    void setVec3(const string &name, float value1, float value2, float value3)const
    {
        glUniform3f(glGetUniformLocation(PID, name.c_str()), value1, value2, value3);
    }
    void setVec3(const string &name, glm::vec3 _vec3)const
    {
        glUniform3f(glGetUniformLocation(PID, name.c_str()), _vec3.x, _vec3.y, _vec3.z);
    }
    void setMatrix4fv(const string &name, const GLfloat *value) const
    {
        glUniformMatrix4fv(glGetUniformLocation(PID, name.c_str()), 1, GL_FALSE, value);
    }
    void setMat4(const std::string &name, const glm::mat4 &mat) const
    {
        glUniformMatrix4fv(glGetUniformLocation(PID, name.c_str()), 1, GL_FALSE, &mat[0][0]);
    }
    
    const char* vertexSource;
    const char* fragmentSource;
    const char* geometrySource;
    GLint PID;//program ID
private:
    string vertexString;
    string fragmentString;
    string geometryString;
    
};

#endif /* Shader_hpp */
