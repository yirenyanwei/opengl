//
//  Material.cpp
//  OpenGLProject
//  材质球
//  Created by yanwei on 2021/3/21.
//  Copyright © 2021 yanwei. All rights reserved.
//

#include "Material.hpp"

Material::Material(Shader &_shader, MaterialInfo &_info):
shader(_shader),
materialInfo(_info)
{
    
}
Material::~Material()
{
    
}

void Material::setMaterialUniform()
{
    shader.setVec3("material.ambient",  materialInfo.ambient);
    shader.setInt("material.diffuse",  materialInfo.diffuse);
    shader.setInt("material.specular", materialInfo.specular);
    shader.setInt("material.emission", materialInfo.emmision);
    shader.setFloat("material.shininess", materialInfo.shininess);
}
