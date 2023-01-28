//
//  LightDirectional.hpp
//  OpenGLProject
//
//  Created by yanwei on 2021/3/28.
//  Copyright © 2021 yanwei. All rights reserved.
//

#ifndef LightDirectional_hpp
#define LightDirectional_hpp

#include <stdio.h>
#include <glm/glm.hpp>
#include <glm/gtx/rotate_vector.hpp>
#include "Shader.hpp"
#include "Light.hpp"

struct LightDirectionalInfo {
    //colors
    glm::vec3 ambient;
    glm::vec3 diffuse;
    glm::vec3 specular;
    
    glm::vec3 direction;// 方向
    glm::vec3 angles; //旋转角度
public:
    void UpdateDirection();//更新方向
};
class LightDirectional {
public:
    LightDirectional(Shader &shader, LightDirectionalInfo &info);
    ~LightDirectional();
    
    LightDirectionalInfo &info;
    Shader &shader;
    
    //设置uniform参数
    void setLightUniform();
};
#endif /* LightDirectional_hpp */
