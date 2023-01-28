//
//  MeshOld.hpp
//  OpenGLProject
//
//  Created by yanwei on 2021/5/30.
//  Copyright © 2021 yanwei. All rights reserved.
//  旧的读取方式

#ifndef MeshOld_hpp
#define MeshOld_hpp

#include <stdio.h>
#include <string>
#include <vector>
#include "glm.hpp"
#include "glad.h"
#include "Shader.hpp"
using namespace std;

struct VertextOld {
    glm::vec3 Position;//位置
//    glm::vec3 Normal;//法向量
    glm::vec2 TexCoords;//图片uv
//    glm::vec3 Tangent;//切线
//    glm::vec3 Bitangent;//双切线
};

struct TextureOld {
    unsigned int id;//图片创建id
    string type;// 图片的用途是漫反射、镜面反射的贴图
    string path;// 图片的路径
};

class MeshOld{
public:
    MeshOld();
    MeshOld(float vertices[], int length);
    MeshOld(vector<VertextOld> vertices,vector<TextureOld> textures);
    ~MeshOld();
    
    vector<VertextOld> vertices;
    vector<TextureOld> textures;
    
    void Draw(Shader shader);
    void DrawNoTexture(Shader shader);
private:
    unsigned int VAO,VBO;
    //OpenGL初始化
    void setupMesh();
    
};

#endif /* MeshOld_hpp */
