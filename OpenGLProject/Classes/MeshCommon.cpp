//
//  MeshCommon.cpp
//  OpenGLProject
//
//  Created by yanwei on 2021/6/19.
//  Copyright © 2021 yanwei. All rights reserved.
//

#include "MeshCommon.hpp"
MeshCommon::MeshCommon()
{
    
}

MeshCommon::~MeshCommon()
{
    
}

MeshCommon::MeshCommon(float vertices[], int length){
    this->vertices.resize(length);
    memcpy(&(this->vertices[0]), vertices, length*sizeof(VertextPNT));
    pointSize = this->vertices.size();
    this->setupMeshPNT();
}

MeshCommon::MeshCommon(vector<VertextPNT> vertices ,vector<TextureCN> textures)
{
    this->vertices = vertices;
    this->textures = textures;
    pointSize = this->vertices.size();
    this->setupMeshPNT();
}

MeshCommon::MeshCommon(vector<VertextPT> vertices ,vector<TextureCN> textures)
{
    this->verticesPT = vertices;
    this->textures = textures;
    pointSize = this->verticesPT.size();
    this->setupMeshPT();
}

MeshCommon::MeshCommon(vector<VertextPN> vertices ,vector<TextureCN> textures)
{
    this->verticesPN = vertices;
    this->textures = textures;
    pointSize = this->verticesPN.size();
    this->setupMeshPN();
}

MeshCommon::MeshCommon(vector<VertextP> vertices ,vector<TextureCN> textures)
{
    this->verticesP = vertices;
    this->textures = textures;
    pointSize = this->verticesP.size();
    this->setupMeshP();
}

MeshCommon::MeshCommon(vector<VertextPNTTB> vertices ,vector<TextureCN> textures)
{
    this->verticesPNTTB = vertices;
    this->textures = textures;
    pointSize = this->verticesPNTTB.size();
    this->setupMeshPNTTB();
}

void MeshCommon::Draw(Shader shader)
{
    //绑定图片
    for (int i = 0; i<textures.size(); i++) {
        TextureCN texture = textures[i];
        glActiveTexture(GL_TEXTURE0+i);
        glBindTexture(GL_TEXTURE_2D,texture.id);
        shader.setInt(texture.type, i);
    }
    // draw mesh
    glBindVertexArray(VAO);
//    glDrawElements(GL_TRIANGLES, (int)indices.size(), GL_UNSIGNED_INT, 0);
    glDrawArrays(GL_TRIANGLES, 0, (int)pointSize);
    //解绑
    glBindVertexArray(0);

    // always good practice to set everything back to defaults once configured.
    glActiveTexture(GL_TEXTURE0);
}

 void MeshCommon::DrawNoTexture(Shader shader)
{
    // draw mesh
    glBindVertexArray(VAO);
    //    glDrawElements(GL_TRIANGLES, (int)indices.size(), GL_UNSIGNED_INT, 0);
    glDrawArrays(GL_TRIANGLES, 0, (int)pointSize);
    //解绑
    glBindVertexArray(0);

    // always good practice to set everything back to defaults once configured.
    glActiveTexture(GL_TEXTURE0);
}


void MeshCommon::DrawPoints(Shader shader)
{
    // draw mesh
    glBindVertexArray(VAO);
//    glDrawElements(GL_TRIANGLES, (int)indices.size(), GL_UNSIGNED_INT, 0);
    glDrawArrays(GL_POINTS, 0, (int)pointSize);
    //解绑
    glBindVertexArray(0);

    // always good practice to set everything back to defaults once configured.
    glActiveTexture(GL_TEXTURE0);
}

void MeshCommon::DrawInstanced(Shader shader, unsigned int instanceNum)
{
    //绑定图片
        for (int i = 0; i<textures.size(); i++) {
            TextureCN texture = textures[i];
            glActiveTexture(GL_TEXTURE0+i);
            glBindTexture(GL_TEXTURE_2D,texture.id);
            shader.setInt(texture.type, i);
        }
        // draw mesh
        glBindVertexArray(VAO);
    //    glDrawElements(GL_TRIANGLES, (int)indices.size(), GL_UNSIGNED_INT, 0);
        glDrawArraysInstanced(GL_TRIANGLES, 0, (int)pointSize, instanceNum);
        //解绑
        glBindVertexArray(0);

        // always good practice to set everything back to defaults once configured.
        glActiveTexture(GL_TEXTURE0);
}

void MeshCommon::setupMeshPNT()
{
    glGenVertexArrays(1, &VAO);
    glBindVertexArray(VAO);
    
    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(VertextPNT)*vertices.size(), &vertices[0], GL_STATIC_DRAW);
    
    //绑定VBO数据
    glEnableVertexAttribArray(0);
    //C++内置的offsetof函数，能自动返回结构对象中，某变量距离结构体对象首地址的偏移值：
    //0号位， 挖3个数据 float类型， 间隔大小， 起始位置
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(VertextPNT), (void *)0);
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(VertextPNT), (void *)offsetof(VertextPNT, Normal));
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, sizeof(VertextPNT), (void *)offsetof(VertextPNT, TexCoords));
    
    //解绑
    glBindVertexArray(0);
}

void MeshCommon::setupMeshPT()
{
    glGenVertexArrays(1, &VAO);
    glBindVertexArray(VAO);
    
    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(VertextPT)*verticesPT.size(), &verticesPT[0], GL_STATIC_DRAW);
    
    //绑定VBO数据
    glEnableVertexAttribArray(0);
    //C++内置的offsetof函数，能自动返回结构对象中，某变量距离结构体对象首地址的偏移值：
    //0号位， 挖3个数据 float类型， 间隔大小， 起始位置
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(VertextPT), (void *)0);
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, sizeof(VertextPT), (void *)offsetof(VertextPT, TexCoords));
    
    //解绑
    glBindVertexArray(0);
}

void MeshCommon::setupMeshPN()
{
    glGenVertexArrays(1, &VAO);
    glBindVertexArray(VAO);
    
    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(VertextPN)*verticesPN.size(), &verticesPN[0], GL_STATIC_DRAW);
    
    //绑定VBO数据
    glEnableVertexAttribArray(0);
    //C++内置的offsetof函数，能自动返回结构对象中，某变量距离结构体对象首地址的偏移值：
    //0号位， 挖3个数据 float类型， 间隔大小， 起始位置
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(VertextPN), (void *)0);
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(VertextPN), (void *)offsetof(VertextPN, Normal));
    
    //解绑
    glBindVertexArray(0);
}

void MeshCommon::setupMeshP()
{
    glGenVertexArrays(1, &VAO);
    glBindVertexArray(VAO);
    
    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(VertextP)*verticesP.size(), &verticesP[0], GL_STATIC_DRAW);
    
    //绑定VBO数据
    glEnableVertexAttribArray(0);
    //C++内置的offsetof函数，能自动返回结构对象中，某变量距离结构体对象首地址的偏移值：
    //0号位， 挖3个数据 float类型， 间隔大小， 起始位置
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(VertextP), (void *)0);
    
    //解绑
    glBindVertexArray(0);
}

void MeshCommon::setupMeshPNTTB()
{
    glGenVertexArrays(1, &VAO);
    glBindVertexArray(VAO);
    
    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(VertextPNTTB)*verticesPNTTB.size(), &verticesPNTTB[0], GL_STATIC_DRAW);
    
    //绑定VBO数据
    glEnableVertexAttribArray(0);
    //C++内置的offsetof函数，能自动返回结构对象中，某变量距离结构体对象首地址的偏移值：
    //0号位， 挖3个数据 float类型， 间隔大小， 起始位置
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(VertextPNTTB), (void *)0);
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(VertextPNTTB), (void *)offsetof(VertextPNTTB, Normal));
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, sizeof(VertextPNTTB), (void *)offsetof(VertextPNTTB, TexCoords));
    glEnableVertexAttribArray(3);
    glVertexAttribPointer(3, 3, GL_FLOAT, GL_FALSE, sizeof(VertextPNTTB), (void *)offsetof(VertextPNTTB, Tangent));
    glEnableVertexAttribArray(4);
    glVertexAttribPointer(4, 3, GL_FLOAT, GL_FALSE, sizeof(VertextPNTTB), (void *)offsetof(VertextPNTTB, Bitangent));
    //解绑
    glBindVertexArray(0);
}
