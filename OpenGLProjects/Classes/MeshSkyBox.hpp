//
//  MeshSkyBox.hpp
//  OpenGLProject
//  天空盒子的渲染
//  Created by yanwei on 2021/6/6.
//  Copyright © 2021 yanwei. All rights reserved.
//

#ifndef MeshSkyBox_hpp
#define MeshSkyBox_hpp

#include <stdio.h>
#include <string>
#include <vector>
#include "glm.hpp"
#include "glad.h"
#include "Shader.hpp"
using namespace std;

struct VertextSky{
    glm::vec3 Position;//位置
//    glm::vec2 TexCoords;//图片uv
};

struct TextureSky {
    unsigned int id;//图片创建id
    string type;// 图片的用途是漫反射、镜面反射的贴图
    string path;// 图片的路径
};

class MeshSkyBox{
public:
    MeshSkyBox();
    MeshSkyBox(vector<VertextSky> vertices,vector<TextureSky> textures);
    ~MeshSkyBox();
    
    vector<VertextSky> vertices;
    vector<TextureSky> textures;
    
    void Draw(Shader shader);
    void DrawNoTexture(Shader shader);
private:
    unsigned int VAO,VBO;
    //OpenGL初始化
    void setupMesh();
    
};

#endif /* MeshSkyBox_hpp */
