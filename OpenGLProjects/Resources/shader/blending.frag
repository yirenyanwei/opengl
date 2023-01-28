#version 330 core
out vec4 FragColor;

in vec2 TexCoords;

uniform sampler2D texture1;

void main()
{
    vec4 texColor = texture(texture1, TexCoords);
    // 已经设置了颜色混合，没必要丢弃
//    if(texColor.a < 0.1)
//        discard;
    FragColor = texColor;
}
