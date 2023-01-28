//
//  MeshSkyBox.cpp
//  OpenGLProject
//
//  Created by yanwei on 2021/6/6.
//  Copyright © 2021 yanwei. All rights reserved.
// 

#include "MeshSkyBox.hpp"
MeshSkyBox::MeshSkyBox()
{
    
}

MeshSkyBox::~MeshSkyBox()
{
    
}

MeshSkyBox::MeshSkyBox(vector<VertextSky> vertices,vector<TextureSky> textures)
{
    this->vertices = vertices;
    this->textures = textures;
    
    this->setupMesh();
}

void MeshSkyBox::Draw(Shader shader)
{
    //绑定图片
    for (int i = 0; i<textures.size(); i++) {
        TextureSky texture = textures[i];
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D,texture.id);
        shader.setInt(texture.type, 0);
    }
    // draw mesh
    glBindVertexArray(VAO);
//    glDrawElements(GL_TRIANGLES, (int)indices.size(), GL_UNSIGNED_INT, 0);
    glDrawArrays(GL_TRIANGLES, 0, this->vertices.size());
    //解绑
    glBindVertexArray(0);

    // always good practice to set everything back to defaults once configured.
    glActiveTexture(GL_TEXTURE0);
}

void MeshSkyBox::DrawNoTexture(Shader shader)
{
    // draw mesh
        glBindVertexArray(VAO);
    //    glDrawElements(GL_TRIANGLES, (int)indices.size(), GL_UNSIGNED_INT, 0);
        glDrawArrays(GL_TRIANGLES, 0, this->vertices.size());
        //解绑
        glBindVertexArray(0);

        // always good practice to set everything back to defaults once configured.
        glActiveTexture(GL_TEXTURE0);
}

void MeshSkyBox::setupMesh()
{
    glGenVertexArrays(1, &VAO);
    glBindVertexArray(VAO);
    
    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(VertextSky)*vertices.size(), &vertices[0], GL_STATIC_DRAW);
    
    //绑定VBO数据
    glEnableVertexAttribArray(0);
    //C++内置的offsetof函数，能自动返回结构对象中，某变量距离结构体对象首地址的偏移值：
    //0号位， 挖3个数据 float类型， 间隔大小， 起始位置
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(VertextSky), (void *)0);
//    glEnableVertexAttribArray(1);
////    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(VertextOld), (void *)offsetof(VertextOld, Normal));
//    glEnableVertexAttribArray(1);
//    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, sizeof(VertextSky), (void *)(3*sizeof(float)));
    
    //解绑
    glBindVertexArray(0);
}
