//
//  MeshCommon.hpp
//  OpenGLProject
//
//  Created by yanwei on 2021/6/19.
//  Copyright © 2021 yanwei. All rights reserved.
//

#ifndef MeshCommon_hpp
#define MeshCommon_hpp

#include <stdio.h>
#include <string>
#include <vector>
#include "glm.hpp"
#include "glad.h"
#include "Shader.hpp"
using namespace std;

struct VertextPNTTB {
    glm::vec3 Position;//位置
    glm::vec3 Normal;//法向量
    glm::vec2 TexCoords;//图片uv
    glm::vec3 Tangent;//切线
    glm::vec3 Bitangent;//副切线
};

struct VertextPNT {
    glm::vec3 Position;//位置
    glm::vec3 Normal;//法向量
    glm::vec2 TexCoords;//图片uv
//    glm::vec3 Tangent;//切线
//    glm::vec3 Bitangent;//双切线
};

struct VertextPT {
    glm::vec3 Position;//位置
//    glm::vec3 Normal;//法向量
    glm::vec2 TexCoords;//图片uv
//    glm::vec3 Tangent;//切线
//    glm::vec3 Bitangent;//双切线
};

struct VertextPN {
    glm::vec3 Position;//位置
    glm::vec3 Normal;//法向量
//    glm::vec2 TexCoords;//图片uv
//    glm::vec3 Tangent;//切线
//    glm::vec3 Bitangent;//双切线
};

struct VertextP {
    glm::vec3 Position;//位置
//    glm::vec3 Normal;//法向量
//    glm::vec2 TexCoords;//图片uv
//    glm::vec3 Tangent;//切线
//    glm::vec3 Bitangent;//双切线
};

struct TextureCN {
    unsigned int id;//图片创建id
    string type;// 图片的用途是漫反射、镜面反射的贴图
    string path;// 图片的路径
};

class MeshCommon{
public:
    MeshCommon();
    MeshCommon(float vertices[], int length);
    MeshCommon(vector<VertextPNT> vertices ,vector<TextureCN> textures);
    MeshCommon(vector<VertextPT> vertices ,vector<TextureCN> textures);
    MeshCommon(vector<VertextPN> vertices ,vector<TextureCN> textures);
    MeshCommon(vector<VertextP> vertices ,vector<TextureCN> textures);
    MeshCommon(vector<VertextPNTTB> vertices ,vector<TextureCN> textures);
    ~MeshCommon();
    
    vector<VertextPNT> vertices;
    vector<VertextPT> verticesPT;
    vector<VertextPN> verticesPN;
    vector<VertextP> verticesP;
    vector<VertextPNTTB> verticesPNTTB;
    vector<TextureCN> textures;
    
    unsigned long pointSize;
    
    inline unsigned int getVAO()
    {
        return VAO;
    }
    
    void Draw(Shader shader);//渲染图形
    void DrawNoTexture(Shader shader);//渲染图形
    void DrawPoints(Shader shader);//渲染点
    void DrawInstanced(Shader shader, unsigned int instanceNum);//渲染实例
private:
    unsigned int VAO,VBO,EBO;
    //OpenGL初始化
    void setupMeshPNT();
    void setupMeshPT();
    void setupMeshPN();
    void setupMeshP();
    void setupMeshPNTTB();
    
};
#endif /* MeshCommon_hpp */
