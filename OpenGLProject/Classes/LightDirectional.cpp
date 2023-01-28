//
//  LightDirectional.cpp
//  OpenGLProject
//
//  Created by yanwei on 2021/3/28.
//  Copyright © 2021 yanwei. All rights reserved.
//

#include "LightDirectional.hpp"

void LightDirectionalInfo::UpdateDirection()//更新方向
{
    //direction//从光源指向物体
    direction = glm::rotateZ(direction, angles.z);
    direction = glm::rotateX(direction, angles.x);
    direction = glm::rotateY(direction, angles.y);
    
    direction = -1.0f*direction;//从物体指向光源
}

LightDirectional::LightDirectional(Shader &_shader, LightDirectionalInfo &_info):
info(_info),
shader(_shader)
{
    info.UpdateDirection();
}
LightDirectional::~LightDirectional()
{
    
}

void LightDirectional::setLightUniform()
{
    shader.setVec3("lightD.ambient",  info.ambient);
    shader.setVec3("lightD.diffuse",  info.diffuse);
    shader.setVec3("lightD.specular", info.specular);
    shader.setVec3("lightD.direction",  info.direction);
}
