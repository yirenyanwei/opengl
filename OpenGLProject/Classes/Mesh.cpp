//
//  Mesh.cpp
//  OpenGLProject
//
//  Created by yanwei on 2021/5/9.
//  Copyright © 2021 yanwei. All rights reserved.
//

#include "Mesh.hpp"

Mesh::Mesh()
{
    
}

Mesh::~Mesh()
{
    
}

Mesh::Mesh(float vertices[], int length){
    this->vertices.resize(length);
    memcpy(&(this->vertices[0]), vertices, length*sizeof(Vertext));
    this->setupMesh();
}

Mesh::Mesh(vector<Vertext> vertices,vector<unsigned int> indices,vector<Texture> textures)
{
    this->vertices = vertices;
    this->indices = indices;
    this->textures = textures;
    
    this->setupMesh();
}

void Mesh::Draw(Shader shader)
{
    //绑定图片
    for (int i = 0; i<textures.size(); i++) {
        Texture texture = textures[i];
        if(texture.type == "texture_diffuse") {
            glActiveTexture(GL_TEXTURE0);
            glBindTexture(GL_TEXTURE_2D,texture.id);
            shader.setInt("material.diffuse", 0);
        }else if(texture.type == "texture_specular") {
            glActiveTexture(GL_TEXTURE1);
            glBindTexture(GL_TEXTURE_2D,texture.id);
            shader.setInt("material.specular", 1);
        }
    }
    // draw mesh
    glBindVertexArray(VAO);
    glDrawElements(GL_TRIANGLES, (int)indices.size(), GL_UNSIGNED_INT, 0);
//    glDrawArrays(GL_TRIANGLES, 0, 36);
    //解绑
    glBindVertexArray(0);

    // always good practice to set everything back to defaults once configured.
    glActiveTexture(GL_TEXTURE0);
}

void Mesh::setupMesh()
{
    glGenVertexArrays(1, &VAO);
    glBindVertexArray(VAO);
    
    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertext)*vertices.size(), &vertices[0], GL_STATIC_DRAW);
    
    glGenBuffers(1, &EBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(unsigned int)*indices.size(), &indices[0], GL_STATIC_DRAW);
    
    //绑定VBO数据
    glEnableVertexAttribArray(0);
    //C++内置的offsetof函数，能自动返回结构对象中，某变量距离结构体对象首地址的偏移值：
    //0号位， 挖3个数据 float类型， 间隔大小， 起始位置
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(Vertext), (void *)0);
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(Vertext), (void *)offsetof(Vertext, Normal));
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, sizeof(Vertext), (void *)offsetof(Vertext, TexCoords));
    
    //解绑
    glBindVertexArray(0);
}
