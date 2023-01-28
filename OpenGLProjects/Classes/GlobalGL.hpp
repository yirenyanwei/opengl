//
//  GlobalGL.hpp
//  OpenGLProject
//
//  Created by yanwei on 2021/9/5.
//  Copyright © 2021 yanwei. All rights reserved.
//

#ifndef GlobalGL_hpp
#define GlobalGL_hpp

#include <stdio.h>
//glm
#include <glad/glad.h>
#include <glm/glm.hpp>

#include <iostream>

#define GL_STACK_OVERFLOW 0x0503
#define GL_STACK_UNDERFLOW 0x0504

extern GLenum glCheckError_(const char *file, int line);
#define glCheckError() glCheckError_(__FILE__, __LINE__)

extern void APIENTRY glDebugOutput(GLenum source,GLenum type,unsigned int id,GLenum severity,GLsizei length,const char *message,const void *userParam);


#endif /* GlobalGL_hpp */
