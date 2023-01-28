#version 330 core
layout(location=0) in vec3 aPos;
layout(location=1) in vec3 aColor;
layout(location=2) in vec2 aTexCoord;

//变换矩阵
uniform mat4 transform;
//3d透视
uniform mat4 modelMat;
uniform mat4 viewMat;
uniform mat4 projMat;

out vec4 vectexColor;
out vec2 TexCoord;
void main(){
    //gl_Position = transform * vec4(aPos,1.0);//矩阵变换
    gl_Position = projMat * viewMat * modelMat * vec4(aPos,1.0);//3d透视
    vectexColor = vec4(aColor, 1.0f);//vec4(1.0, 0.0, 0.0, 1.0);
    TexCoord = aTexCoord;
}
