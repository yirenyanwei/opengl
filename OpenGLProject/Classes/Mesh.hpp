//
//  Mesh.hpp
//  OpenGLProject
//
//  Created by yanwei on 2021/5/9.
//  Copyright © 2021 yanwei. All rights reserved.
//

#ifndef Mesh_hpp
#define Mesh_hpp

#include <stdio.h>
#include <string>
#include <vector>
#include "glm.hpp"
#include "glad.h"
#include "Shader.hpp"
using namespace std;

struct Vertext {
    glm::vec3 Position;//位置
    glm::vec3 Normal;//法向量
    glm::vec2 TexCoords;//图片uv
//    glm::vec3 Tangent;//切线
//    glm::vec3 Bitangent;//双切线
};

struct Texture {
    unsigned int id;//图片创建id
    string type;// 图片的用途是漫反射、镜面反射的贴图
    string path;// 图片的路径
};

class Mesh{
public:
    unsigned int VAO,VBO,EBO;
    
    Mesh();
    Mesh(float vertices[], int length);
    Mesh(vector<Vertext> vertices,vector<unsigned int> indices,vector<Texture> textures);
    ~Mesh();
    
    vector<Vertext> vertices;
    vector<unsigned int> indices;
    vector<Texture> textures;
    
    void Draw(Shader shader);
private:
    //OpenGL初始化
    void setupMesh();
    
};
#endif /* Mesh_hpp */
