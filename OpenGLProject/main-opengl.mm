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
#include "Shader.hpp"
#include "Camera.hpp"
#include "Material.hpp"
#include "Light.hpp"
#include "LightDirectional.hpp"
#include "LightPoint.hpp"
#include "LightSpot.hpp"
//glm
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
//assimp
#include <assimp/Importer.hpp>
//mash
#include "Mesh.hpp"
#include "MeshOld.hpp"
#include "MeshSkyBox.hpp"
#include "MeshCommon.hpp"
//model
#include "Model.hpp"
//debug
#include "GlobalGL.hpp"
//freeType
//#include <ft2build.h>
//#include FT_FREETYPE_H
#include "FreeTypeLoad.hpp"

using namespace std;

// 通过ASSIMP读文件
Assimp::Importer importer;

void drawColors();
GLuint loadAndUseShader();
void renderScene(const Shader &shader, MeshCommon &plantM, MeshCommon &boxM);
void renderCube();
void renderQuad();

// settings
const unsigned int SCR_WIDTH = 800;
const unsigned int SCR_HEIGHT = 600;

bool blinn = true;
bool blinnKeyPressed = false;

bool hdr = true;
bool hdrKeyPressed = false;
float exposure = 1.0f;
bool bloom = true;
bool bloomKeyPressed = false;

//#pragma mark ModelData
//绘制三角形
//    float vertices[] = {
//        //     ---- 位置 ----       ---- 颜色 ----     - 纹理坐标 -
//         0.5f,  0.5f, 0.0f,   1.0f, 0.0f, 0.0f,   1.0f, 1.0f,   // 右上
//         0.5f, -0.5f, 0.0f,   0.0f, 1.0f, 0.0f,   1.0f, 0.0f,   // 右下
//        -0.5f, -0.5f, 0.0f,   0.0f, 0.0f, 1.0f,   0.0f, 0.0f,   // 左下
//        -0.5f,  0.5f, 0.0f,   1.0f, 1.0f, 0.0f,   0.0f, 1.0f    // 左上
//
//    };
    
    unsigned int indices[] = {
        0, 1, 2,//三角形
        2, 3, 0//三角形2
    };
    //立方体
    float cubeVertices[] = {
        // Back face
        -0.5f, -0.5f, -0.5f,  0.0f, 0.0f, // Bottom-left
         0.5f,  0.5f, -0.5f,  1.0f, 1.0f, // top-right
         0.5f, -0.5f, -0.5f,  1.0f, 0.0f, // bottom-right
         0.5f,  0.5f, -0.5f,  1.0f, 1.0f, // top-right
        -0.5f, -0.5f, -0.5f,  0.0f, 0.0f, // bottom-left
        -0.5f,  0.5f, -0.5f,  0.0f, 1.0f, // top-left
        // Front face
        -0.5f, -0.5f,  0.5f,  0.0f, 0.0f, // bottom-left
         0.5f, -0.5f,  0.5f,  1.0f, 0.0f, // bottom-right
         0.5f,  0.5f,  0.5f,  1.0f, 1.0f, // top-right
         0.5f,  0.5f,  0.5f,  1.0f, 1.0f, // top-right
        -0.5f,  0.5f,  0.5f,  0.0f, 1.0f, // top-left
        -0.5f, -0.5f,  0.5f,  0.0f, 0.0f, // bottom-left
        // Left face
        -0.5f,  0.5f,  0.5f,  1.0f, 0.0f, // top-right
        -0.5f,  0.5f, -0.5f,  1.0f, 1.0f, // top-left
        -0.5f, -0.5f, -0.5f,  0.0f, 1.0f, // bottom-left
        -0.5f, -0.5f, -0.5f,  0.0f, 1.0f, // bottom-left
        -0.5f, -0.5f,  0.5f,  0.0f, 0.0f, // bottom-right
        -0.5f,  0.5f,  0.5f,  1.0f, 0.0f, // top-right
        // Right face
         0.5f,  0.5f,  0.5f,  1.0f, 0.0f, // top-left
         0.5f, -0.5f, -0.5f,  0.0f, 1.0f, // bottom-right
         0.5f,  0.5f, -0.5f,  1.0f, 1.0f, // top-right
         0.5f, -0.5f, -0.5f,  0.0f, 1.0f, // bottom-right
         0.5f,  0.5f,  0.5f,  1.0f, 0.0f, // top-left
         0.5f, -0.5f,  0.5f,  0.0f, 0.0f, // bottom-left
        // Bottom face
        -0.5f, -0.5f, -0.5f,  0.0f, 1.0f, // top-right
         0.5f, -0.5f, -0.5f,  1.0f, 1.0f, // top-left
         0.5f, -0.5f,  0.5f,  1.0f, 0.0f, // bottom-left
         0.5f, -0.5f,  0.5f,  1.0f, 0.0f, // bottom-left
        -0.5f, -0.5f,  0.5f,  0.0f, 0.0f, // bottom-right
        -0.5f, -0.5f, -0.5f,  0.0f, 1.0f, // top-right
        // Top face
        -0.5f,  0.5f, -0.5f,  0.0f, 1.0f, // top-left
         0.5f,  0.5f,  0.5f,  1.0f, 0.0f, // bottom-right
         0.5f,  0.5f, -0.5f,  1.0f, 1.0f, // top-right
         0.5f,  0.5f,  0.5f,  1.0f, 0.0f, // bottom-right
        -0.5f,  0.5f, -0.5f,  0.0f, 1.0f, // top-left
        -0.5f,  0.5f,  0.5f,  0.0f, 0.0f  // bottom-left
    };
float transparentVertices[] = {
    // positions         // texture Coords (swapped y coordinates because texture is flipped upside down)
    0.0f,  0.5f,  0.0f,  0.0f,  0.0f,
    0.0f, -0.5f,  0.0f,  0.0f,  1.0f,
    1.0f, -0.5f,  0.0f,  1.0f,  1.0f,

    0.0f,  0.5f,  0.0f,  0.0f,  0.0f,
    1.0f, -0.5f,  0.0f,  1.0f,  1.0f,
    1.0f,  0.5f,  0.0f,  1.0f,  0.0f
};
vector<glm::vec3> vegetation
{
   glm::vec3(-1.5f, 0.0f, -0.48f),
   glm::vec3( 1.5f, 0.0f, 0.51f),
   glm::vec3( 0.0f, 0.0f, 0.7f),
   glm::vec3(-0.3f, 0.0f, -2.3f),
   glm::vec3 (0.5f, 0.0f, -0.6f)
};
float vertices[] = {
    // positions          // normals           // texture coords
    -0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,  0.0f, 0.0f,
     0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,  1.0f, 0.0f,
     0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,  1.0f, 1.0f,
     0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,  1.0f, 1.0f,
    -0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,  0.0f, 1.0f,
    -0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,  0.0f, 0.0f,

    -0.5f, -0.5f,  0.5f,  0.0f,  0.0f, 1.0f,   0.0f, 0.0f,
     0.5f, -0.5f,  0.5f,  0.0f,  0.0f, 1.0f,   1.0f, 0.0f,
     0.5f,  0.5f,  0.5f,  0.0f,  0.0f, 1.0f,   1.0f, 1.0f,
     0.5f,  0.5f,  0.5f,  0.0f,  0.0f, 1.0f,   1.0f, 1.0f,
    -0.5f,  0.5f,  0.5f,  0.0f,  0.0f, 1.0f,   0.0f, 1.0f,
    -0.5f, -0.5f,  0.5f,  0.0f,  0.0f, 1.0f,   0.0f, 0.0f,

    -0.5f,  0.5f,  0.5f, -1.0f,  0.0f,  0.0f,  1.0f, 0.0f,
    -0.5f,  0.5f, -0.5f, -1.0f,  0.0f,  0.0f,  1.0f, 1.0f,
    -0.5f, -0.5f, -0.5f, -1.0f,  0.0f,  0.0f,  0.0f, 1.0f,
    -0.5f, -0.5f, -0.5f, -1.0f,  0.0f,  0.0f,  0.0f, 1.0f,
    -0.5f, -0.5f,  0.5f, -1.0f,  0.0f,  0.0f,  0.0f, 0.0f,
    -0.5f,  0.5f,  0.5f, -1.0f,  0.0f,  0.0f,  1.0f, 0.0f,

     0.5f,  0.5f,  0.5f,  1.0f,  0.0f,  0.0f,  1.0f, 0.0f,
     0.5f,  0.5f, -0.5f,  1.0f,  0.0f,  0.0f,  1.0f, 1.0f,
     0.5f, -0.5f, -0.5f,  1.0f,  0.0f,  0.0f,  0.0f, 1.0f,
     0.5f, -0.5f, -0.5f,  1.0f,  0.0f,  0.0f,  0.0f, 1.0f,
     0.5f, -0.5f,  0.5f,  1.0f,  0.0f,  0.0f,  0.0f, 0.0f,
     0.5f,  0.5f,  0.5f,  1.0f,  0.0f,  0.0f,  1.0f, 0.0f,

    -0.5f, -0.5f, -0.5f,  0.0f, -1.0f,  0.0f,  0.0f, 1.0f,
     0.5f, -0.5f, -0.5f,  0.0f, -1.0f,  0.0f,  1.0f, 1.0f,
     0.5f, -0.5f,  0.5f,  0.0f, -1.0f,  0.0f,  1.0f, 0.0f,
     0.5f, -0.5f,  0.5f,  0.0f, -1.0f,  0.0f,  1.0f, 0.0f,
    -0.5f, -0.5f,  0.5f,  0.0f, -1.0f,  0.0f,  0.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,  0.0f, -1.0f,  0.0f,  0.0f, 1.0f,

    -0.5f,  0.5f, -0.5f,  0.0f,  1.0f,  0.0f,  0.0f, 1.0f,
     0.5f,  0.5f, -0.5f,  0.0f,  1.0f,  0.0f,  1.0f, 1.0f,
     0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,  1.0f, 0.0f,
     0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,  1.0f, 0.0f,
    -0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,  0.0f, 0.0f,
    -0.5f,  0.5f, -0.5f,  0.0f,  1.0f,  0.0f,  0.0f, 1.0f
};
    
//10个立方体
glm::vec3 cubePositions[] = {
    glm::vec3( 0.0f,  0.0f,  0.0f),
    glm::vec3( 2.0f,  5.0f, -15.0f),
    glm::vec3(-1.5f, -2.2f, -2.5f),
    glm::vec3(-3.8f, -2.0f, -12.3f),
    glm::vec3( 2.4f, -0.4f, -3.5f),
    glm::vec3(-1.7f,  3.0f, -7.5f),
    glm::vec3( 1.3f, -2.0f, -2.5f),
    glm::vec3( 1.5f,  2.0f, -2.5f),
    glm::vec3( 1.5f,  0.2f, -1.5f),
    glm::vec3(-1.3f,  1.0f, -1.5f)
};

// positions of the point lights
glm::vec3 pointLightPositions[] = {
    glm::vec3( 0.7f,  0.2f,  2.0f),
    glm::vec3( 2.3f, -3.3f, -4.0f),
    glm::vec3(-4.0f,  2.0f, -12.0f),
    glm::vec3( 0.0f,  0.0f, -3.0f)
};

float quadVertices[] = { // vertex attributes for a quad that fills the entire screen in Normalized Device Coordinates.
    // positions   // texCoords
    -1.0f,  1.0f,  0.0f,  0.0f, 1.0f,
    -1.0f, -1.0f,  0.0f,  0.0f, 0.0f,
     1.0f, -1.0f,  0.0f,  1.0f, 0.0f,

    -1.0f,  1.0f,  0.0f,  0.0f, 1.0f,
     1.0f, -1.0f,  0.0f,  1.0f, 0.0f,
     1.0f,  1.0f,  0.0f,  1.0f, 1.0f
};

float skyboxVertices[] = {
       // positions
       -1.0f,  1.0f, -1.0f,
       -1.0f, -1.0f, -1.0f,
        1.0f, -1.0f, -1.0f,
        1.0f, -1.0f, -1.0f,
        1.0f,  1.0f, -1.0f,
       -1.0f,  1.0f, -1.0f,

       -1.0f, -1.0f,  1.0f,
       -1.0f, -1.0f, -1.0f,
       -1.0f,  1.0f, -1.0f,
       -1.0f,  1.0f, -1.0f,
       -1.0f,  1.0f,  1.0f,
       -1.0f, -1.0f,  1.0f,

        1.0f, -1.0f, -1.0f,
        1.0f, -1.0f,  1.0f,
        1.0f,  1.0f,  1.0f,
        1.0f,  1.0f,  1.0f,
        1.0f,  1.0f, -1.0f,
        1.0f, -1.0f, -1.0f,

       -1.0f, -1.0f,  1.0f,
       -1.0f,  1.0f,  1.0f,
        1.0f,  1.0f,  1.0f,
        1.0f,  1.0f,  1.0f,
        1.0f, -1.0f,  1.0f,
       -1.0f, -1.0f,  1.0f,

       -1.0f,  1.0f, -1.0f,
        1.0f,  1.0f, -1.0f,
        1.0f,  1.0f,  1.0f,
        1.0f,  1.0f,  1.0f,
       -1.0f,  1.0f,  1.0f,
       -1.0f,  1.0f, -1.0f,

       -1.0f, -1.0f, -1.0f,
       -1.0f, -1.0f,  1.0f,
        1.0f, -1.0f, -1.0f,
        1.0f, -1.0f, -1.0f,
       -1.0f, -1.0f,  1.0f,
        1.0f, -1.0f,  1.0f
   };
float skycubeVertices[] = {
       // positions          // normals
       -0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,
        0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,
        0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,
        0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,
       -0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,
       -0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,

       -0.5f, -0.5f,  0.5f,  0.0f,  0.0f, 1.0f,
        0.5f, -0.5f,  0.5f,  0.0f,  0.0f, 1.0f,
        0.5f,  0.5f,  0.5f,  0.0f,  0.0f, 1.0f,
        0.5f,  0.5f,  0.5f,  0.0f,  0.0f, 1.0f,
       -0.5f,  0.5f,  0.5f,  0.0f,  0.0f, 1.0f,
       -0.5f, -0.5f,  0.5f,  0.0f,  0.0f, 1.0f,

       -0.5f,  0.5f,  0.5f, -1.0f,  0.0f,  0.0f,
       -0.5f,  0.5f, -0.5f, -1.0f,  0.0f,  0.0f,
       -0.5f, -0.5f, -0.5f, -1.0f,  0.0f,  0.0f,
       -0.5f, -0.5f, -0.5f, -1.0f,  0.0f,  0.0f,
       -0.5f, -0.5f,  0.5f, -1.0f,  0.0f,  0.0f,
       -0.5f,  0.5f,  0.5f, -1.0f,  0.0f,  0.0f,

        0.5f,  0.5f,  0.5f,  1.0f,  0.0f,  0.0f,
        0.5f,  0.5f, -0.5f,  1.0f,  0.0f,  0.0f,
        0.5f, -0.5f, -0.5f,  1.0f,  0.0f,  0.0f,
        0.5f, -0.5f, -0.5f,  1.0f,  0.0f,  0.0f,
        0.5f, -0.5f,  0.5f,  1.0f,  0.0f,  0.0f,
        0.5f,  0.5f,  0.5f,  1.0f,  0.0f,  0.0f,

       -0.5f, -0.5f, -0.5f,  0.0f, -1.0f,  0.0f,
        0.5f, -0.5f, -0.5f,  0.0f, -1.0f,  0.0f,
        0.5f, -0.5f,  0.5f,  0.0f, -1.0f,  0.0f,
        0.5f, -0.5f,  0.5f,  0.0f, -1.0f,  0.0f,
       -0.5f, -0.5f,  0.5f,  0.0f, -1.0f,  0.0f,
       -0.5f, -0.5f, -0.5f,  0.0f, -1.0f,  0.0f,

       -0.5f,  0.5f, -0.5f,  0.0f,  1.0f,  0.0f,
        0.5f,  0.5f, -0.5f,  0.0f,  1.0f,  0.0f,
        0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,
        0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,
       -0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,
       -0.5f,  0.5f, -0.5f,  0.0f,  1.0f,  0.0f
   };

float cubeUniformBufferVertices[] = {
    // positions
    -0.5f, -0.5f, -0.5f,
     0.5f, -0.5f, -0.5f,
     0.5f,  0.5f, -0.5f,
     0.5f,  0.5f, -0.5f,
    -0.5f,  0.5f, -0.5f,
    -0.5f, -0.5f, -0.5f,

    -0.5f, -0.5f,  0.5f,
     0.5f, -0.5f,  0.5f,
     0.5f,  0.5f,  0.5f,
     0.5f,  0.5f,  0.5f,
    -0.5f,  0.5f,  0.5f,
    -0.5f, -0.5f,  0.5f,

    -0.5f,  0.5f,  0.5f,
    -0.5f,  0.5f, -0.5f,
    -0.5f, -0.5f, -0.5f,
    -0.5f, -0.5f, -0.5f,
    -0.5f, -0.5f,  0.5f,
    -0.5f,  0.5f,  0.5f,

     0.5f,  0.5f,  0.5f,
     0.5f,  0.5f, -0.5f,
     0.5f, -0.5f, -0.5f,
     0.5f, -0.5f, -0.5f,
     0.5f, -0.5f,  0.5f,
     0.5f,  0.5f,  0.5f,

    -0.5f, -0.5f, -0.5f,
     0.5f, -0.5f, -0.5f,
     0.5f, -0.5f,  0.5f,
     0.5f, -0.5f,  0.5f,
    -0.5f, -0.5f,  0.5f,
    -0.5f, -0.5f, -0.5f,

    -0.5f,  0.5f, -0.5f,
     0.5f,  0.5f, -0.5f,
     0.5f,  0.5f,  0.5f,
     0.5f,  0.5f,  0.5f,
    -0.5f,  0.5f,  0.5f,
    -0.5f,  0.5f, -0.5f,
};

float points[] = {
    -0.5f,  0.5f, 0, 1.0f, 0.0f, 0.0f, // top-left
     0.5f,  0.5f, 0, 0.0f, 1.0f, 0.0f, // top-right
     0.5f, -0.5f, 0, 0.0f, 0.0f, 1.0f, // bottom-right
    -0.5f, -0.5f, 0, 1.0f, 1.0f, 0.0f, // bottom-left
};

//实例化
float instanceVertices[] = {
    // positions     // colors
    -0.05f,  0.05f,  0,  1.0f, 0.0f, 0.0f,
     0.05f, -0.05f,  0,  0.0f, 1.0f, 0.0f,
    -0.05f, -0.05f,  0,  0.0f, 0.0f, 1.0f,

    -0.05f,  0.05f,  0,  1.0f, 0.0f, 0.0f,
     0.05f, -0.05f,  0,  0.0f, 1.0f, 0.0f,
     0.05f,  0.05f,  0,  0.0f, 1.0f, 1.0f
};
// 地面
float planeVertices[] = {
    // positions            // normals         // texcoords
     25.0f, -0.5f,  25.0f,  0.0f, 1.0f, 0.0f,  25.0f,  0.0f,
    -25.0f, -0.5f,  25.0f,  0.0f, 1.0f, 0.0f,   0.0f,  0.0f,
    -25.0f, -0.5f, -25.0f,  0.0f, 1.0f, 0.0f,   0.0f, 25.0f,

     25.0f, -0.5f,  25.0f,  0.0f, 1.0f, 0.0f,  25.0f,  0.0f,
    -25.0f, -0.5f, -25.0f,  0.0f, 1.0f, 0.0f,   0.0f, 25.0f,
     25.0f, -0.5f, -25.0f,  0.0f, 1.0f, 0.0f,  25.0f, 25.0f
};
float shadowBoxVertices[] = {
    // back face
    -1.0f, -1.0f, -1.0f,  0.0f,  0.0f, -1.0f, 0.0f, 0.0f, // bottom-left
     1.0f,  1.0f, -1.0f,  0.0f,  0.0f, -1.0f, 1.0f, 1.0f, // top-right
     1.0f, -1.0f, -1.0f,  0.0f,  0.0f, -1.0f, 1.0f, 0.0f, // bottom-right
     1.0f,  1.0f, -1.0f,  0.0f,  0.0f, -1.0f, 1.0f, 1.0f, // top-right
    -1.0f, -1.0f, -1.0f,  0.0f,  0.0f, -1.0f, 0.0f, 0.0f, // bottom-left
    -1.0f,  1.0f, -1.0f,  0.0f,  0.0f, -1.0f, 0.0f, 1.0f, // top-left
    // front face
    -1.0f, -1.0f,  1.0f,  0.0f,  0.0f,  1.0f, 0.0f, 0.0f, // bottom-left
     1.0f, -1.0f,  1.0f,  0.0f,  0.0f,  1.0f, 1.0f, 0.0f, // bottom-right
     1.0f,  1.0f,  1.0f,  0.0f,  0.0f,  1.0f, 1.0f, 1.0f, // top-right
     1.0f,  1.0f,  1.0f,  0.0f,  0.0f,  1.0f, 1.0f, 1.0f, // top-right
    -1.0f,  1.0f,  1.0f,  0.0f,  0.0f,  1.0f, 0.0f, 1.0f, // top-left
    -1.0f, -1.0f,  1.0f,  0.0f,  0.0f,  1.0f, 0.0f, 0.0f, // bottom-left
    // left face
    -1.0f,  1.0f,  1.0f, -1.0f,  0.0f,  0.0f, 1.0f, 0.0f, // top-right
    -1.0f,  1.0f, -1.0f, -1.0f,  0.0f,  0.0f, 1.0f, 1.0f, // top-left
    -1.0f, -1.0f, -1.0f, -1.0f,  0.0f,  0.0f, 0.0f, 1.0f, // bottom-left
    -1.0f, -1.0f, -1.0f, -1.0f,  0.0f,  0.0f, 0.0f, 1.0f, // bottom-left
    -1.0f, -1.0f,  1.0f, -1.0f,  0.0f,  0.0f, 0.0f, 0.0f, // bottom-right
    -1.0f,  1.0f,  1.0f, -1.0f,  0.0f,  0.0f, 1.0f, 0.0f, // top-right
    // right face
     1.0f,  1.0f,  1.0f,  1.0f,  0.0f,  0.0f, 1.0f, 0.0f, // top-left
     1.0f, -1.0f, -1.0f,  1.0f,  0.0f,  0.0f, 0.0f, 1.0f, // bottom-right
     1.0f,  1.0f, -1.0f,  1.0f,  0.0f,  0.0f, 1.0f, 1.0f, // top-right
     1.0f, -1.0f, -1.0f,  1.0f,  0.0f,  0.0f, 0.0f, 1.0f, // bottom-right
     1.0f,  1.0f,  1.0f,  1.0f,  0.0f,  0.0f, 1.0f, 0.0f, // top-left
     1.0f, -1.0f,  1.0f,  1.0f,  0.0f,  0.0f, 0.0f, 0.0f, // bottom-left
    // bottom face
    -1.0f, -1.0f, -1.0f,  0.0f, -1.0f,  0.0f, 0.0f, 1.0f, // top-right
     1.0f, -1.0f, -1.0f,  0.0f, -1.0f,  0.0f, 1.0f, 1.0f, // top-left
     1.0f, -1.0f,  1.0f,  0.0f, -1.0f,  0.0f, 1.0f, 0.0f, // bottom-left
     1.0f, -1.0f,  1.0f,  0.0f, -1.0f,  0.0f, 1.0f, 0.0f, // bottom-left
    -1.0f, -1.0f,  1.0f,  0.0f, -1.0f,  0.0f, 0.0f, 0.0f, // bottom-right
    -1.0f, -1.0f, -1.0f,  0.0f, -1.0f,  0.0f, 0.0f, 1.0f, // top-right
    // top face
    -1.0f,  1.0f, -1.0f,  0.0f,  1.0f,  0.0f, 0.0f, 1.0f, // top-left
     1.0f,  1.0f , 1.0f,  0.0f,  1.0f,  0.0f, 1.0f, 0.0f, // bottom-right
     1.0f,  1.0f, -1.0f,  0.0f,  1.0f,  0.0f, 1.0f, 1.0f, // top-right
     1.0f,  1.0f,  1.0f,  0.0f,  1.0f,  0.0f, 1.0f, 0.0f, // bottom-right
    -1.0f,  1.0f, -1.0f,  0.0f,  1.0f,  0.0f, 0.0f, 1.0f, // top-left
    -1.0f,  1.0f,  1.0f,  0.0f,  1.0f,  0.0f, 0.0f, 0.0f  // bottom-left
};

float lerp(float a, float b, float f)
{
    return a + f * (b - a);
}
//#pragma mark -

void loadImage(const char *imagePath,GLint internalformat){
    int width, height, nrChannel;
    //OpenGL要求y轴0.0坐标是在图片的底部的，但是图片的y轴0.0坐标通常在顶部
    stbi_set_flip_vertically_on_load(true);
    unsigned char *data = stbi_load(imagePath, &width, &height, &nrChannel, 0);
    printf("container.jpg--%d, %d, %d\n", width, height, nrChannel);
    if(data){
        //我们可以使用前面载入的图片数据生成一个纹理
        glTexImage2D(GL_TEXTURE_2D, 0, internalformat, width, height, 0, internalformat, GL_UNSIGNED_BYTE, data);
        //创建 多级渐远纹理
        glGenerateMipmap(GL_TEXTURE_2D);
    }else{
        printf("%s", "读取图片错误");
    }
    stbi_image_free(data);
}

unsigned int loadTexture(char const * path, bool gammaCorrection = false)
{
    unsigned int textureID;
    glGenTextures(1, &textureID);

    int width, height, nrComponents;
    unsigned char *data = stbi_load(path, &width, &height, &nrComponents, 0);
    if (data)
    {
        GLenum internalFormat;
        GLenum dataFormat;
        if (nrComponents == 1)
        {
            internalFormat = dataFormat = GL_RED;
        }
        else if (nrComponents == 3)
        {
            internalFormat = gammaCorrection ? GL_SRGB : GL_RGB;
            dataFormat = GL_RGB;
        }
        else if (nrComponents == 4)
        {
            internalFormat = gammaCorrection ? GL_SRGB_ALPHA : GL_RGBA;
            dataFormat = GL_RGBA;
        }

        glBindTexture(GL_TEXTURE_2D, textureID);
        glTexImage2D(GL_TEXTURE_2D, 0, internalFormat, width, height, 0, dataFormat, GL_UNSIGNED_BYTE, data);
        glGenerateMipmap(GL_TEXTURE_2D);

        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

        stbi_image_free(data);
    }

    return textureID;
}

unsigned int loadCubemap(vector<string> faces)
{
    unsigned int textureID;
    glGenTextures(1, &textureID);
    glBindTexture(GL_TEXTURE_CUBE_MAP, textureID);
    
    int width, height, nrChannels;
    // 6个面
    for (unsigned int i = 0; i < faces.size(); i++)
    {
        unsigned char *data = stbi_load(faces[i].c_str(), &width, &height, &nrChannels, 0);
        if (data)
        {
            glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X + i, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, data);
            stbi_image_free(data);
        }
        else
        {
            std::cout << "Cubemap texture failed to load at path: " << faces[i] << std::endl;
            stbi_image_free(data);
        }
    }
    // 为当前绑定的纹理对象设置环绕、过滤方式
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_R, GL_CLAMP_TO_EDGE);
    return textureID;
}

MeshOld createGrassMesh()
{
    vector<VertextOld> vertices;
    vector<TextureOld> textures;
    
    int length = 6;
    vertices.resize(length);
    memcpy(&(vertices[0]), transparentVertices, length*sizeof(VertextOld));
    
    unsigned int textureID = loadTexture("images/blending_transparent_window.png");
    TextureOld to = {
        textureID,
        "texture1",
        "images/grass.png"
    };
    textures.push_back(to);
    
    return MeshOld(vertices, textures);
}

MeshOld createBoxMesh()
{
    vector<VertextOld> vertices;
    vector<TextureOld> textures;
    
    int length = 36;
    vertices.resize(length);
    memcpy(&(vertices[0]), cubeVertices, length*sizeof(VertextOld));
    
    unsigned int textureID = loadTexture("container2.png");
    TextureOld to = {
        textureID,
        "texture1",
        "container2.png"
    };
    textures.push_back(to);
    
    return MeshOld(vertices, textures);
}

MeshOld createScreenMesh()
{
    //framebuffer
    vector<VertextOld> vertices;
    vector<TextureOld> textures;
    
    int length = 6;
    vertices.resize(length);
    memcpy(&(vertices[0]), quadVertices, length*sizeof(VertextOld));
    
    unsigned int textureID = loadTexture("container2.png");
    TextureOld to = {
        textureID,
        "depthMap",
        "container2.png"
    };
    textures.push_back(to);
    
    return MeshOld(vertices, textures);
}

MeshSkyBox createSkyBoxMesh()
{
    vector<VertextSky> vertices;
    vector<TextureSky> textures;
    
    int length = 36;
    vertices.resize(length);
    memcpy(&(vertices[0]), skyboxVertices, length*sizeof(VertextSky));
    
    vector<std::string> faces
       {
           "images/skybox/right.jpg",
           "images/skybox/left.jpg",
           "images/skybox/top.jpg",
           "images/skybox/bottom.jpg",
           "images/skybox/front.jpg",
           "images/skybox/back.jpg"
       };
    
    unsigned int cubemapTexture = loadCubemap(faces);
    TextureSky to = {
        cubemapTexture,
        "skybox",
        "images/skybox"
    };
    textures.push_back(to);
    
    return MeshSkyBox(vertices, textures);
}

MeshCommon createSkyCubeMesh()
{
    vector<VertextPN> vertices;
    vector<TextureCN> textures;
    
    int length = 36;
    vertices.resize(length);
    memcpy(&(vertices[0]), skycubeVertices, length*sizeof(VertextPN));
    
    vector<std::string> faces
       {
           "images/skybox/right.jpg",
           "images/skybox/left.jpg",
           "images/skybox/top.jpg",
           "images/skybox/bottom.jpg",
           "images/skybox/front.jpg",
           "images/skybox/back.jpg"
       };
    
    unsigned int cubemapTexture = loadCubemap(faces);
    TextureCN to = {
        cubemapTexture,
        "skybox",
        "images/skybox"
    };
    textures.push_back(to);
    
    return MeshCommon(vertices, textures);
}

MeshCommon createUniformBufferCubeMesh()
{
    //几何着色器
    vector<VertextP> vertices;
   vector<TextureCN> textures;
   
   int length = 36;
   vertices.resize(length);
   memcpy(&(vertices[0]), cubeUniformBufferVertices, length*sizeof(VertextP));
   
   return MeshCommon(vertices, textures);
}

MeshCommon createGeometryMesh()
{
    vector<VertextPN> vertices;
    vector<TextureCN> textures;
    
    int length = 4;
    vertices.resize(length);
    memcpy(&(vertices[0]), points, length*sizeof(VertextPN));
    
    return MeshCommon(vertices, textures);
}

MeshCommon createInstancedMesh()
{
    vector<VertextPN> vertices;
    vector<TextureCN> textures;
    
    int length = 6;
    vertices.resize(length);
    memcpy(&(vertices[0]), instanceVertices, length*sizeof(VertextPN));
    
    return MeshCommon(vertices, textures);
}

MeshCommon createPlantMesh()
{
    vector<VertextPNT> vertices;
    vector<TextureCN> textures;
    
    int length = 6;
    vertices.resize(length);
    memcpy(&(vertices[0]), planeVertices, length*sizeof(VertextPNT));
    
    unsigned int textureID = loadTexture("images/wood.png");
    TextureCN to = {
        textureID,
        "floorTexture",
        "images/wood.png"
    };
    textures.push_back(to);
    
    return MeshCommon(vertices, textures);
}

MeshCommon createShadowBoxMesh()
{
    vector<VertextPNT> vertices;
    vector<TextureCN> textures;
    
    int length = 36;
    vertices.resize(length);
    memcpy(&(vertices[0]), shadowBoxVertices, length*sizeof(VertextPNT));
    
    unsigned int textureID = loadTexture("images/wood.png");
    TextureCN to = {
        textureID,
        "diffuseTexture",
        "images/wood.png"
    };
    textures.push_back(to);
    
    return MeshCommon(vertices, textures);
}

MeshCommon createParallaxMesh()
{

    // positions
    glm::vec3 pos1(-1.0, 1.0, 0.0);
    glm::vec3 pos2(-1.0, -1.0, 0.0);
    glm::vec3 pos3(1.0, -1.0, 0.0);
    glm::vec3 pos4(1.0, 1.0, 0.0);
    // texture coordinates
    glm::vec2 uv1(0.0, 1.0);
    glm::vec2 uv2(0.0, 0.0);
    glm::vec2 uv3(1.0, 0.0);
    glm::vec2 uv4(1.0, 1.0);
    // normal vector
    glm::vec3 nm(0.0, 0.0, 1.0);

    // calculate tangent/bitangent vectors of both triangles
    glm::vec3 tangent1, bitangent1;
    glm::vec3 tangent2, bitangent2;
    // - triangle 1
    glm::vec3 edge1 = pos2 - pos1;
    glm::vec3 edge2 = pos3 - pos1;
    glm::vec2 deltaUV1 = uv2 - uv1;
    glm::vec2 deltaUV2 = uv3 - uv1;

    GLfloat f = 1.0f / (deltaUV1.x * deltaUV2.y - deltaUV2.x * deltaUV1.y);

    tangent1.x = f * (deltaUV2.y * edge1.x - deltaUV1.y * edge2.x);
    tangent1.y = f * (deltaUV2.y * edge1.y - deltaUV1.y * edge2.y);
    tangent1.z = f * (deltaUV2.y * edge1.z - deltaUV1.y * edge2.z);
    tangent1 = glm::normalize(tangent1);

    bitangent1.x = f * (-deltaUV2.x * edge1.x + deltaUV1.x * edge2.x);
    bitangent1.y = f * (-deltaUV2.x * edge1.y + deltaUV1.x * edge2.y);
    bitangent1.z = f * (-deltaUV2.x * edge1.z + deltaUV1.x * edge2.z);
    bitangent1 = glm::normalize(bitangent1);

    // - triangle 2
    edge1 = pos3 - pos1;
    edge2 = pos4 - pos1;
    deltaUV1 = uv3 - uv1;
    deltaUV2 = uv4 - uv1;

    f = 1.0f / (deltaUV1.x * deltaUV2.y - deltaUV2.x * deltaUV1.y);

    tangent2.x = f * (deltaUV2.y * edge1.x - deltaUV1.y * edge2.x);
    tangent2.y = f * (deltaUV2.y * edge1.y - deltaUV1.y * edge2.y);
    tangent2.z = f * (deltaUV2.y * edge1.z - deltaUV1.y * edge2.z);
    tangent2 = glm::normalize(tangent2);


    bitangent2.x = f * (-deltaUV2.x * edge1.x + deltaUV1.x * edge2.x);
    bitangent2.y = f * (-deltaUV2.x * edge1.y + deltaUV1.x * edge2.y);
    bitangent2.z = f * (-deltaUV2.x * edge1.z + deltaUV1.x * edge2.z);
    bitangent2 = glm::normalize(bitangent2);


    GLfloat quadVertices[] = {
        // Positions            // normal         // TexCoords  // Tangent                          // Bitangent
        pos1.x, pos1.y, pos1.z, nm.x, nm.y, nm.z, uv1.x, uv1.y, tangent1.x, tangent1.y, tangent1.z, bitangent1.x, bitangent1.y, bitangent1.z,
        pos2.x, pos2.y, pos2.z, nm.x, nm.y, nm.z, uv2.x, uv2.y, tangent1.x, tangent1.y, tangent1.z, bitangent1.x, bitangent1.y, bitangent1.z,
        pos3.x, pos3.y, pos3.z, nm.x, nm.y, nm.z, uv3.x, uv3.y, tangent1.x, tangent1.y, tangent1.z, bitangent1.x, bitangent1.y, bitangent1.z,

        pos1.x, pos1.y, pos1.z, nm.x, nm.y, nm.z, uv1.x, uv1.y, tangent2.x, tangent2.y, tangent2.z, bitangent2.x, bitangent2.y, bitangent2.z,
        pos3.x, pos3.y, pos3.z, nm.x, nm.y, nm.z, uv3.x, uv3.y, tangent2.x, tangent2.y, tangent2.z, bitangent2.x, bitangent2.y, bitangent2.z,
        pos4.x, pos4.y, pos4.z, nm.x, nm.y, nm.z, uv4.x, uv4.y, tangent2.x, tangent2.y, tangent2.z, bitangent2.x, bitangent2.y, bitangent2.z
    };
    vector<VertextPNTTB> vertices;
    vector<TextureCN> textures;
    
    int length = 6;
    vertices.resize(length);
    memcpy(&(vertices[0]), quadVertices, length*sizeof(VertextPNTTB));
    
    unsigned int textureID = loadTexture("images/bricks2.jpeg");
    TextureCN to = {
        textureID,
        "diffuseMap",
        "images/bricks2.png"
    };
    textures.push_back(to);
    
    textureID = loadTexture("images/bricks2_normal.jpeg");
    to = {
        textureID,
        "normalMap",
        "images/bricks2_normal.png"
    };
    textures.push_back(to);
    
    textureID = loadTexture("images/bricks2_disp.jpeg");
    to = {
        textureID,
        "depthMap",
        "images/bricks2_disp.png"
    };
    textures.push_back(to);
    
    return MeshCommon(vertices, textures);
}

MeshCommon createCommonScreenMesh()
{
    //framebuffer
    vector<VertextPT> vertices;
    vector<TextureCN> textures;
    
    int length = 6;
    vertices.resize(length);
    memcpy(&(vertices[0]), quadVertices, length*sizeof(VertextPT));
    
    unsigned int textureID = loadTexture("container2.png");
    TextureCN to = {
        textureID,
        "depthMap",
        "container2.png"
    };
    textures.push_back(to);
    
    return MeshCommon(vertices, textures);
}

//Camera Instantiate
//Camera camera(glm::vec3(0,0,3.0f), glm::vec3(0,0,0), glm::vec3(0,1.0f,0));
Camera camera(glm::vec3(0,0,3.0f), glm::radians(0.0f), glm::radians(180.0f), glm::vec3(0,1.0f,0));//欧拉角的方式初始化

//#pragma mark Input
//鼠标输入
float lastX;
float lastY;
bool firstMouse = true;
float lastFrame = 0;//上一帧时间戳
float deltaTime = 0;
void framebuffer_size_callback(GLFWwindow* window, int width, int height);//回调函数原型声明
void processInput(GLFWwindow *window);
void mouse_callback(GLFWwindow* window, double xpos, double ypos);
//#pragam mark -

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
    //无论我们怎么去移动鼠标，光标都不会显示了，它也不会离开窗口
    glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_DISABLED);
    //鼠标一移动mouse_callback函数就会被调用
    glfwSetCursorPosCallback(window, mouse_callback);
    
    stbi_set_flip_vertically_on_load(true);
//#pragam mark -
    
    //背面剔除 //逆时针作为正面
//    glEnable(GL_CULL_FACE);
//    glCullFace(GL_BACK);
    //开启深度测试
    glEnable(GL_DEPTH_TEST);
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
    
    /**  mesh.setupMesh()
//#program mark VAO,VBO,EBO
    GLuint VAO, VBO;
    
    glGenVertexArrays(1, &VAO);//创建1个VAO Vetex Array Object generate
    glBindVertexArray(VAO);//绑定VAO 的Arry Buff上
    
    glGenBuffers(1, &VBO);//创建VBO Vetex Buffer Object
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    //glBufferData是一个专门用来把用户定义的数据复制到当前绑定缓冲的函数; 把cup的顶点数据传到gpu中
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    unsigned int EBO;
    glGenBuffers(1, &EBO);//创建EBO Element Buffer Object
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);//缓冲的类型定义为GL_ELEMENT_ARRAY_BUFFER
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    //告诉OpenGL该如何解析顶点数据（应用到逐个顶点属性上） 设置的顶点属性配置VAO的属性 调用与顶点属性关联的顶点缓冲对象
    //0号 位置
    glVertexAttribPointer(0,3,GL_FLOAT,GL_FALSE,8*sizeof(float),(void*)0);//0号特征值 layout(location=0)
    //0号位 以顶点属性位置值作为参数，启用顶点属性 启用VAO
    glEnableVertexAttribArray(0);
    
    //颜色属性 1号 颜色
//    glVertexAttribPointer(1,3,GL_FLOAT,GL_FALSE,8*sizeof(float),(void*)(3*sizeof(float)));//取3个float的值，步长是8个float，起点是3个float
//    glEnableVertexAttribArray(1);
    
    //法线向量 2号 法向量
    glVertexAttribPointer(2,3,GL_FLOAT,GL_FALSE,8*sizeof(float),(void*)(3*sizeof(float)));//3号位置取3个float的值，步长是8个float，起点是3个float
    glEnableVertexAttribArray(2);
    
    //图片属性 3号位置 图片uv
    glVertexAttribPointer(3,2,GL_FLOAT,GL_FALSE,8*sizeof(float),(void*)(6*sizeof(float)));//2号位置 取2个float的值，步长是8个float，起点是6个float
    glEnableVertexAttribArray(3);
    
    //解绑VAO
    glBindBuffer(GL_ARRAY_BUFFER,0);
    glBindVertexArray(0);
//#pragma mark -
    **/
//    Mesh mesh(vertices, 36);
    MeshOld meshGrass = createGrassMesh();
    MeshOld meshBox = createBoxMesh();
    MeshSkyBox meshSkyBox = createSkyBoxMesh();
    MeshCommon meshSkyCube = createSkyCubeMesh();
    MeshCommon meshUniformBufferRed = createUniformBufferCubeMesh();
    MeshCommon meshUniformBufferGreen = createUniformBufferCubeMesh();
    MeshCommon meshUniformBufferBlue = createUniformBufferCubeMesh();
    MeshCommon meshUniformBufferYellow = createUniformBufferCubeMesh();
    MeshCommon meshGeometry = createGeometryMesh();
    MeshCommon meshInstanced = createInstancedMesh();
    //shadow
    MeshCommon meshPlant = createPlantMesh();
    MeshCommon meshShadowBox = createShadowBoxMesh();
    MeshOld meshScreen = createScreenMesh();
    //normalMap
//    MeshCommon meshNormal = createNormalMesh();
    //parallaxMap
    MeshCommon meshParallax = createParallaxMesh();
    //hdr 用到 meshShadowBox meshScreen
    
    //bloom 用到 meshShadowBox meshScreen
    MeshCommon meshCommonScreen = createCommonScreenMesh();

//#pragma mark Texture
    //texture
//    glActiveTexture(GL_TEXTURE0);
    unsigned int TexBufferDiffuse = loadTexture("container2.png");
    //textureB
//    glActiveTexture(GL_TEXTURE2);
    unsigned int TexBufferSpecular = loadTexture("container2_specular.png");
    //GL_TEXTURE3
    unsigned int emissionMap = loadTexture("matrix.jpg");
//#pragma mark -
    
    Shader shader = Shader("vertexSource.vert", "fragmentSource.frag");
    Shader shaderSingleColor = Shader("vertexSource.vert", "shaderSingleColor.frag");
    //颜色混合
    Shader shaderBlending = Shader("shader/blending.vert", "shader/blending.frag");
    //帧缓冲
    Shader shaderFrameBuffer = Shader("shader/framebuffers_screen.vert", "shader/framebuffers_screen.frag");
    //skybox
    Shader shaderSkyBox = Shader("shader/skybox.vert", "shader/skybox.frag");
    Shader shaderSkyCube = Shader("shader/skycube.vert", "shader/skycube.frag");
    //uniformBuffer
    Shader shaderRed = Shader("shader/uniformBufferRed.vert", "shader/uniformBufferRed.frag");
    Shader shaderGreen = Shader("shader/uniformBufferGreen.vert", "shader/uniformBufferGreen.frag");
    Shader shaderBlue = Shader("shader/uniformBufferBlue.vert", "shader/uniformBufferBlue.frag");
    Shader shaderYellow = Shader("shader/uniformBufferYellow.vert", "shader/uniformBufferYellow.frag");
    //几何着色器
    Shader shaderGeometry = Shader("shader/geometry.vs", "shader/geometry.fs", "shader/geometry.gs");
    Shader shaderNormal = Shader("shader/normal.vs", "shader/normal.fs", "shader/normal.gs");
    //实例渲染
    Shader shaderInstanced = Shader("shader/instancing.vs", "shader/instancing.fs");
    Shader shaderInstancedRock = Shader("shader/instanceRock.vs", "shader/instanceRock.fs");
    Shader shaderInstancedPlanet = Shader("shader/instancePlanet.vs", "shader/instancePlanet.fs");
    //抗锯齿
    Shader shaderAntiAliasing = Shader("shader/blending.vert", "shader/uniformBufferGreen.frag");
    //Blinn
    Shader shaderBlinn = Shader("shader/advanced_lighting.vs", "shader/advanced_lighting.fs");
    //shadow
    Shader shaderShadowDepth = Shader("shader/shadow_mapping/shadow_mapping_depth.vs", "shader/shadow_mapping/shadow_mapping_depth.fs");
    Shader shaderDebugDepthQuad = Shader("shader/shadow_mapping/debug_quad.vs", "shader/shadow_mapping/debug_quad.fs");
    Shader shaderShadow = Shader("shader/shadow_mapping/shadow_mapping.vs", "shader/shadow_mapping/shadow_mapping.fs");
    //point shaows
    Shader shaderPShadowsDepth = Shader("shader/shadow_mapping/point_shadows_depth.vs", "shader/shadow_mapping/point_shadows_depth.fs", "shader/shadow_mapping/point_shadows_depth.gs");
    Shader shaderPShadows = Shader("shader/shadow_mapping/point_shadows.vs", "shader/shadow_mapping/point_shadows.fs");
    //normal map
    Shader shaderNormalMp = Shader("shader/normal_mapping/normal_mapping.vs", "shader/normal_mapping/normal_mapping.fs");
    //parallax map
    Shader shaderParallax = Shader("shader/parallax_mapping/parallax_mapping.vs", "shader/parallax_mapping/parallax_mapping.fs");
    //hdr
    Shader shaderHDRLight = Shader("shader/hdr/lighting.vs", "shader/hdr/lighting.fs");
    Shader shaderHDR = Shader("shader/hdr/hdr.vs", "shader/hdr/hdr.fs");
    
    //bloom  泛光，灯光处的光晕
    Shader shaderBloom("shader/bloom/bloom.vs", "shader/bloom/bloom.fs");
    Shader shaderBloomLight("shader/bloom/bloom.vs", "shader/bloom/light_box.fs");
    Shader shaderBloomBlur("shader/bloom/blur.vs", "shader/bloom/blur.fs");
    Shader shaderBloomFinal("shader/bloom/bloom_final.vs", "shader/bloom/bloom_final.fs");
    
    //deferred shading 延迟渲染
    Shader shaderGbuffer("shader/deferred_shading/g_buffer.vs", "shader/deferred_shading/g_buffer.fs");
    Shader shaderDefferredShading("shader/deferred_shading/deferred_shading.vs", "shader/deferred_shading/deferred_shading.fs");
    Shader shaderDefferredBox("shader/deferred_shading/deferred_light_box.vs", "shader/deferred_shading/deferred_light_box.fs");
    
    //ssao
    Shader shaderGeometryPass("shader/ssao/ssao_geometry.vs", "shader/ssao/ssao_geometry.fs");
    Shader shaderLightingPass("shader/ssao/ssao.vs", "shader/ssao/ssao_lighting.fs");
    Shader shaderSSAO("shader/ssao/ssao.vs", "shader/ssao/ssao.fs");
    Shader shaderSSAOBlur("shader/ssao/ssao.vs", "shader/ssao/ssao_blur.fs");
    //text
    Shader shaderText("shader/text/text.vs", "shader/text/text.fs");
    
    //Model
//    Model model("model/nanosuit/nanosuit.obj");
//    Model modelRock("model/rock/rock.obj");
//    Model modelPlanet("model/planet/planet.obj");
//    Model backpack("model/backpack/backpack.obj");
    
    // free type
    FreeTypeLoad freeTypeLoad("fonts/Arial.ttf");
    
    // lighting info test
    // -------------
    glm::vec3 lightPosTest(0.0f, 0.0f, 0.0f);

    
    MaterialInfo mInfo = {
        glm::vec3(0.2f, 0.2f, 0.2f),
        glm::uint(0),
        glm::uint(1),
        glm::uint(2),
        32.0f
    };
    Material material = Material(shader, mInfo);
    LightInfo lInfo = {
        glm::vec3(0.0f, 0.0f, 2.0f),//position
        glm::vec3(0.2f, 0.2f, 0.2f),
        glm::vec3(0.5f, 0.5f, 0.5f),
        glm::vec3(1.0f, 1.0f, 1.0f),
    };
//    Light light = Light(shader, lInfo);
    
    LightDirectionalInfo ldInfo = {
        glm::vec3(0.05f, 0.05f, 0.05f),
        glm::vec3(0.4f, 0.4f, 0.4f),
        glm::vec3(0.5f, 0.5f, 0.5f),
        glm::vec3(-0.0f, -0.0f, -1.0f), // direction 从光源出发(光源在物体前边)
        glm::vec3(glm::radians(-45.0f), 0, 0),// angle（照向正方向上方向,镜面反射在下边）
    };
    LightDirectional lightD = LightDirectional(shader, ldInfo);
    
    LightPointInfo lpInfo0 = {
        glm::vec3(0.05f, 0.05f, 0.05f),
        glm::vec3(0.8f, 0.0f, 0.0f),
        glm::vec3(1.0f, 1.0f, 1.0f),
        glm::vec3(0.0f,  0.2f,  2.0f), // 光源的位置
        1.0f,0.09f, 0.032f,//衰减系数
    };
    LightPoint lightP0 = LightPoint(shader, lpInfo0);
    LightPointInfo lpInfo1 = {
        glm::vec3(0.05f, 0.05f, 0.05f),
        glm::vec3(0.0f, 0.8f, 0.0f),
        glm::vec3(1.0f, 1.0f, 1.0f),
        glm::vec3(2.0f,  0.2f,  2.0f), // 光源的位置
        1.0f,0.09f, 0.032f,//衰减系数
    };
    LightPoint lightP1 = LightPoint(shader, lpInfo1);
    LightPointInfo lpInfo2 = {
        glm::vec3(0.05f, 0.05f, 0.05f),
        glm::vec3(0.0f, 0.0f, 0.8f),
        glm::vec3(1.0f, 1.0f, 1.0f),
        glm::vec3(-2.0f,  0.2f,  2.0f), // 光源的位置
        1.0f,0.09f, 0.032f,//衰减系数
    };
    LightPoint lightP2 = LightPoint(shader, lpInfo2);
    LightPointInfo lpInfo3 = {
        glm::vec3(0.05f, 0.05f, 0.05f),
        glm::vec3(0.0f, 0.8f, 0.8f),
        glm::vec3(1.0f, 1.0f, 1.0f),
        glm::vec3(0.0f,  0.0f, -3.0f), // 光源的位置
        1.0f,0.09f, 0.032f,//衰减系数
    };
    LightPoint lightP3 = LightPoint(shader, lpInfo3);
    LightPoint lightPs[4] = {lightP0, lightP1, lightP2, lightP3};
    char *lightPTitle = new char[10];
    
    LightSpotInfo lsInfo = {
        glm::vec3(0.05f, 0.05f, 0.05f),
        glm::vec3(0.7f, 0.7f, 0.7f),
        glm::vec3(1.0f, 1.0f, 1.0f),
        glm::vec3(1.0f, 1.0f, 2.0f), // 光源的位置
        glm::vec3(1.0f, 1.0f, 2.0f),// 光源的方向
        glm::cos(glm::radians(12.5f)),//光源的半径
        glm::cos(glm::radians(17.5f)),//光源的外圆半径
    };
    LightSpot lightS = LightSpot(shader, lsInfo);
    
//    GLuint shaderProgram = loadAndUseShader();//加载着色器
    
//#pragma mark MVP
    //变换矩阵
    glm::mat4 trans;
//    trans = glm::translate(trans, glm::vec3(-1.0f, 0.0f, 0.0f));//位移
//    trans = glm::rotate(trans, glm::radians(45.0f), glm::vec3(0,0,1.0f));//z轴旋转45
//    trans = glm::scale(trans, glm::vec3(2.0f, 2.0f, 2.0f));//缩放
    //组合 先缩放后旋转
//    trans = glm::rotate(trans, glm::radians(90.0f), glm::vec3(0.0, 0.0, 1.0));
//    trans = glm::scale(trans, glm::vec3(0.5, 0.5, 0.5));
    
    //3d透视b转换
    glm::mat4 modelMat;
//    modelMat = glm::rotate(modelMat, glm::radians(-55.0f), glm::vec3(1.0f, 0, 0));//x轴旋转 转化为世界坐标
    glm::mat4 viewMat;
//    viewMat = glm::translate(viewMat, glm::vec3(0, 0, -3.0f));// 距离远点3  转换为摄像机坐标
    glm::mat4 projMat;
    projMat = glm::perspective(glm::radians(45.0f), 800.0f/600.0f, 0.1f, 100.0f);//转换为透视的裁剪空间
    
    //正交 原点位于左下点
    glm::mat4 projection = glm::ortho(0.0f, static_cast<float>(SCR_WIDTH), 0.0f, static_cast<float>(SCR_HEIGHT));
//#pragma mark -
    
    //1检测错误码
    std::cout <<"before:" << glGetError()<<"\n" << std::endl;
    // 2检查错误码
//        glBindVertexArray(-1);
    glCheckError();
    //3调试输出 要检查我们是否成功地初始化了调试上下文，我们可以对OpenGL进行查询：
    GLint flags;
    glGetIntegerv(GL_CONTEXT_FLAGS, &flags);
    
    
    //渲染循环
    while(!glfwWindowShouldClose(window))
    {
        // deal time
        float currentFrame = glfwGetTime();
        deltaTime = currentFrame - lastFrame;
        lastFrame = currentFrame;
        
        // 输入
        processInput(window);
        
//        trans = glm::rotate(trans, glm::radians(1.0f), glm::vec3(0,0,1.0f));//旋转动画
        //变换效果
//        glm::mat4 trans;
//        trans = glm::translate(trans, glm::vec3(0.5f, -0.5f, 0.0f));
//        trans = glm::rotate(trans, (float)glfwGetTime(), glm::vec3(0.0f, 0.0f, 1.0f));

        // 渲染指令
        glClearColor(0.2f, 0.3f, 0.3f, 1.0f);//清空屏幕所用的颜色
//        glClear(GL_COLOR_BUFFER_BIT);//清空x颜色缓冲
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);//清空颜色缓冲  深度测试  模板测试
        //激活shader ->shader program 第一步
//        glUseProgram(shaderProgram);
        
        shader.use();
        //更新uniform颜色
        float timeValue = glfwGetTime();
        float greenValue = sin(timeValue)/2.0f +0.5f;//0-1
//        int vertexColorLocation = glGetUniformLocation(shaderProgram, "ourColor");
//        glUniform4f(vertexColorLocation, 0, greenValue, 0, 1.0f);
        float values[] = {0, greenValue, 0, 1.0f};
        shader.set4Float("ourColor", values);
        //设置图片参数
        shader.setInt("ourTexture", 0);
        shader.setInt("ourTextureB", 2);
        //变换矩阵
        shader.setMatrix4fv("transform", glm::value_ptr(trans));
        //用摄像机的形式
        viewMat = camera.GetViewMatrix();
        //3d透视 Material->Uniforms 第二步
        shader.setMatrix4fv("modelMat", glm::value_ptr(modelMat));
        shader.setMatrix4fv("viewMat", glm::value_ptr(viewMat));
        shader.setMatrix4fv("projMat", glm::value_ptr(projMat));
        //设置光照
        float value3O[] = {1.0f, 1.0f, 1.0f};
        shader.set3Float("objColor", value3O);// 物体颜色
        float value3V[] = {camera.Position.x, camera.Position.y, camera.Position.z};
        shader.set3Float("viewPos", value3V);//眼睛的位置 即摄像机的位置
//        light.setTimeTransform(timeValue);
        lsInfo.position = camera.Position;//更新聚光灯的位置，方向
        lsInfo.direction = camera.Forward;
        lightD.setLightUniform();//光照参数
        for(int i = 0; i<4; i++) {
            sprintf(lightPTitle, "%s%d%s", "lightPoints[", i, "]");
            lightPs[i].setLightUniform(lightPTitle);//光照参数
        }
        lightS.setLightUniform();//光照参数
        //Material
        material.setMaterialUniform();//材质参数
        /**
        //绑定图片 Material->Texture 第三步
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, TexBufferDiffuse);
        glActiveTexture(GL_TEXTURE2);
        glBindTexture(GL_TEXTURE_2D, TexBufferSpecular);
        // bind emission map
        glActiveTexture(GL_TEXTURE3);
        glBindTexture(GL_TEXTURE_2D, emissionMap);
        //绑定VAO  同时会自动B绑定EBO Set Model 第四步
        glBindVertexArray(VAO);
        **/
        
        //meshShadowBox meshScreen
        shaderText.use();
        shaderText.setMatrix4fv("projection", glm::value_ptr(projection));
        freeTypeLoad.RenderText(shaderText, "This is sample text", 25.0f, 25.0f, 1.0f, glm::vec3(0.5, 0.8f, 0.2f));
        freeTypeLoad.RenderText(shaderText, "(C) LearnOpenGL.com", 540.0f, 570.0f, 0.5f, glm::vec3(0.3, 0.7f, 0.9f));
        
        
        // Clean up
        //解绑VAO
        glBindVertexArray(0);
        // 检查并调用事件，交换缓冲
        glfwSwapBuffers(window);//交换颜色缓冲
        glfwPollEvents();    //检查触发事件
        
        // 检查错误码
//        glBindVertexArray(-1);
        glCheckError();
    }

    //释放/删除之前的分配的所有资源
    glfwTerminate();
    return EXIT_SUCCESS;
}

//输入控制，检查用户是否按下了返回键(Esc)
void processInput(GLFWwindow *window)
{
    if(glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS){
        glfwSetWindowShouldClose(window, true);
    }
    if (glfwGetKey(window, GLFW_KEY_W) == GLFW_PRESS){
        camera.ProcessKeyboard(FORWARD, deltaTime);
    }
    if (glfwGetKey(window, GLFW_KEY_S) == GLFW_PRESS){
        camera.ProcessKeyboard(BACKWARD, deltaTime);
    }
    if (glfwGetKey(window, GLFW_KEY_A) == GLFW_PRESS){
        camera.ProcessKeyboard(LEFT, deltaTime);
    }
    if (glfwGetKey(window, GLFW_KEY_D) == GLFW_PRESS){
        camera.ProcessKeyboard(RIGHT, deltaTime);
    }
    if (glfwGetKey(window, GLFW_KEY_Q) == GLFW_PRESS){
        camera.ProcessKeyboard(UP, deltaTime);
    }
    if (glfwGetKey(window, GLFW_KEY_E) == GLFW_PRESS){
        camera.ProcessKeyboard(BOTTOM, deltaTime);
    }
    
    if (glfwGetKey(window, GLFW_KEY_B) == GLFW_PRESS && !blinnKeyPressed)
    {
        blinn = !blinn;
        blinnKeyPressed = true;
    }
    if (glfwGetKey(window, GLFW_KEY_B) == GLFW_RELEASE)
    {
        blinnKeyPressed = false;
    }
    
    if (glfwGetKey(window, GLFW_KEY_SPACE) == GLFW_PRESS && !bloomKeyPressed)
    {
        bloom = !bloom;
        bloomKeyPressed = true;
    }
    if (glfwGetKey(window, GLFW_KEY_SPACE) == GLFW_RELEASE)
    {
        bloomKeyPressed = false;
    }
    if (glfwGetKey(window, GLFW_KEY_O) == GLFW_PRESS)
    {
        if (exposure > 0.0f)
            exposure -= 0.001f;
        else
            exposure = 0.0f;
    }
    else if (glfwGetKey(window, GLFW_KEY_P) == GLFW_PRESS)
    {
        exposure += 0.001f;
    }
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
    camera.ProcessMouseMovement(deltaX, deltaY);
}

GLuint loadAndUseShader()
{
    //废弃，从文件中读取
    const char* vertexCode =
    "#version 330 core\n"
    "layout(location=0) in vec3 aPos;"
    "layout(location=1) in vec3 aColor;"
    "out vec4 vectexColor;"
    "void main(){"
    "gl_Position=vec4(aPos,1.0);"
    "vectexColor = vec4(aColor, 1.0f);//vec4(1.0, 0.0, 0.0, 1.0);\n"
    "}";
    const char* fragmentCode =
    "#version 330 core\n"
    "out vec4 FragColor;"
    "in vec4 vectexColor;"
    "uniform vec4 ourColor;"
    "void main(){"
    "//FragColor=vec4(1.0,0.5,0.0,1.0);//直接赋值 \n"
    "FragColor = vectexColor;//从定点着色器中传值 \n"
    "//FragColor = ourColor;//从cup中输入全局变量的值 \n"
    "}";
    
    GLuint vertex,fragment;
    vertex = glCreateShader(GL_VERTEX_SHADER);//创建着色器
    glShaderSource(vertex, 1, &vertexCode, nullptr);//把这个着色器源码附加到着色器对象上
    glCompileShader(vertex);//编译
    
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
    //着色器程序对象(Shader Program Object)是多个着色器合并之后并最终链接完成的版本
    //函数创建一个程序，并返回新创建程序对象的ID引用
    GLuint PID = glCreateProgram();
    
    glAttachShader(PID, vertex);//附加
    glAttachShader(PID, fragment);
    
    glLinkProgram(PID);//链接
    
    glGetProgramiv(PID, GL_LINK_STATUS,&success);//获取日志
    if(!success)
    {
        glGetProgramInfoLog(PID,512, nullptr,infoLog);
        cout<<"ERROR:PROGRAM\n"<<infoLog<<endl;
    }
    //激活这个程序对象
    glUseProgram(PID);
    //记得删除着色器对象
    glDeleteShader(vertex);
    glDeleteShader(fragment);
    
    return PID;
}

// renders the 3D scene
// --------------------
void renderScene(const Shader &shader, MeshCommon &plantM, MeshCommon &boxM)
{
    // room cube
    glm::mat4 model = glm::mat4(1.0f);
    model = glm::scale(model, glm::vec3(5.0f));
    shader.setMat4("model", model);
    glDisable(GL_CULL_FACE); // note that we disable culling here since we render 'inside' the cube instead of the usual 'outside' which throws off the normal culling methods.
    shader.setInt("reverse_normals", 1); // A small little hack to invert normals when drawing cube from the inside so lighting still works.
    boxM.DrawNoTexture(shader);
    shader.setInt("reverse_normals", 0); // and of course disable it
    glEnable(GL_CULL_FACE);
    // cubes
    model = glm::mat4(1.0f);
    model = glm::translate(model, glm::vec3(4.0f, -3.5f, 0.0));
    model = glm::scale(model, glm::vec3(0.5f));
    shader.setMat4("model", model);
    boxM.DrawNoTexture(shader);
    model = glm::mat4(1.0f);
    model = glm::translate(model, glm::vec3(2.0f, 3.0f, 1.0));
    model = glm::scale(model, glm::vec3(0.75f));
    shader.setMat4("model", model);
    boxM.DrawNoTexture(shader);
    model = glm::mat4(1.0f);
    model = glm::translate(model, glm::vec3(-3.0f, -1.0f, 0.0));
    model = glm::scale(model, glm::vec3(0.5f));
    shader.setMat4("model", model);
    boxM.DrawNoTexture(shader);
    model = glm::mat4(1.0f);
    model = glm::translate(model, glm::vec3(-1.5f, 1.0f, 1.5));
    model = glm::scale(model, glm::vec3(0.5f));
    shader.setMat4("model", model);
    boxM.DrawNoTexture(shader);
    model = glm::mat4(1.0f);
    model = glm::translate(model, glm::vec3(-1.5f, 2.0f, -3.0));
    model = glm::rotate(model, glm::radians(60.0f), glm::normalize(glm::vec3(1.0, 0.0, 1.0)));
    model = glm::scale(model, glm::vec3(0.75f));
    shader.setMat4("model", model);
    boxM.DrawNoTexture(shader);
}

void renderCube(){
    
}
void renderQuad()
{
}

