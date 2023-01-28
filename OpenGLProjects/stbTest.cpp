//
//  stbTest.cpp
//  OpenGLProject
//
//  Created by yanwei on 2021/1/31.
//  Copyright © 2021 yanwei. All rights reserved.
//

#include <stdio.h>
#include <iostream>
//#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

int main3(int argc, char * argv[]){
    
    int width, height, nrChannels;
    //坐标的问题，需要翻转。OpenGL左下角  图片左上角
    stbi_set_flip_vertically_on_load(true);
    //读文件
    unsigned char *data = stbi_load("container.jpg", &width, &height, &nrChannels, 0);
//    printf("%s", data);
    if(data) {
        for (int i = 0; i<10*10; i++) {
            printf("%d\n", (int)data[i]);
        }
    }
    //释放
    stbi_image_free(data);
    
    //glm
    std::cout<<"glm \n"<<std::endl;
    glm::vec4 vec(1.0f, 0.0f, 0.0f, 1.0f);//齐次坐标
    // 译注：下面就是矩阵初始化的一个例子，如果使用的是0.9.9及以上版本
    // 下面这行代码就需要改为:
    // glm::mat4 trans = glm::mat4(1.0f)
    // 之后将不再进行提示
    glm::mat4 trans;//4x4 单位矩阵 matrix
    trans = glm::translate(trans, glm::vec3(1.0f, 1.0f, 0.0f));
    vec = trans * vec;
    std::cout << vec.x << vec.y << vec.z << std::endl;
    return 0;
}
