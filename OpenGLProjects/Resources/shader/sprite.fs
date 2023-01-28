#version 330 core
in vec2 TexCoords;
out vec4 color;

uniform sampler2D image;
uniform vec3 spriteColor;

void main()
{
    //通过spriteColor改变精灵的颜色
    color = vec4(spriteColor, 1.0) * texture(image, TexCoords);
} 
