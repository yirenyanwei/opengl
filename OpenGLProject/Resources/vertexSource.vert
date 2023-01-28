#version 330 core
layout(location=0) in vec3 aPos;
layout(location=4) in vec3 aColor;
layout(location=1) in vec3 aNormal;
layout(location=2) in vec2 aTexCoord;

//变换矩阵
uniform mat4 transform;
//3d透视
uniform mat4 modelMat;
uniform mat4 viewMat;
uniform mat4 projMat;

out vec4 vectexColor;
out vec2 TexCoord;
//光照
out vec3 FragPos;
out vec3 Normal;
out VS_OUT{
    vec2 TexCoord;
    vec4 vectexColor;
    vec3 FragPos;
    vec3 Normal;
}vs_out;
void main(){
    //gl_Position = transform * vec4(aPos,1.0);//矩阵变换
    gl_Position = projMat * viewMat * modelMat * vec4(aPos,1.0);//3d透视
    vectexColor = vec4(aColor, 1.0f);//vec4(1.0, 0.0, 0.0, 1.0);
    TexCoord = aTexCoord;
    //光照 转化为世界坐标计算
    Normal = mat3(transpose(inverse(modelMat))) * aNormal;//法线矩阵 转职矩阵的逆矩阵
    FragPos = vec3(modelMat * vec4(aPos, 1.0f));//像素坐标
    
    vs_out.TexCoord = aTexCoord;
    vs_out.vectexColor = vectexColor;
    vs_out.FragPos = FragPos;
    vs_out.Normal = Normal;
}
