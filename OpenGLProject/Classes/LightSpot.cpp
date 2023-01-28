//
//  LightSpot.cpp
//  OpenGLProject
//
//  Created by yanwei on 2021/4/11.
//  Copyright © 2021 yanwei. All rights reserved.
//

#include "LightSpot.hpp"
LightSpot::LightSpot(Shader &_shader, LightSpotInfo &_info):
info(_info),
shader(_shader)
{
    
}
LightSpot::~LightSpot()
{
    
}

void LightSpot::setLightUniform()
{
    shader.setVec3("lightS.ambient",  info.ambient);
    shader.setVec3("lightS.diffuse",  info.diffuse);
    shader.setVec3("lightS.specular", info.specular);
    shader.setVec3("lightS.position",  info.position);
    shader.setVec3("lightS.direction",  info.direction);
    shader.setFloat("lightS.cutOff",  info.cutOff);
    shader.setFloat("lightS.outerCutOff",  info.outerCutOff);
}
