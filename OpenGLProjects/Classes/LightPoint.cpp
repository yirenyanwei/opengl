//
//  LightPoint.cpp
//  OpenGLProject
//
//  Created by yanwei on 2021/4/11.
//  Copyright © 2021 yanwei. All rights reserved.
//

#include "LightPoint.hpp"
LightPoint::LightPoint(Shader &_shader, LightPointInfo &_info):
info(_info),
shader(_shader)
{
    
}
LightPoint::~LightPoint()
{
    
}

void LightPoint::setLightUniform(string title)
{
    shader.setVec3(title+".ambient",  info.ambient);
    shader.setVec3(title+".diffuse",  info.diffuse);
    shader.setVec3(title+".specular", info.specular);
    shader.setVec3(title+".position",  info.position);
    shader.setFloat(title+".constant", info.constant);
    shader.setFloat(title+".linear", info.linear);
    shader.setFloat(title+".quadratic", info.quadratic);
}
