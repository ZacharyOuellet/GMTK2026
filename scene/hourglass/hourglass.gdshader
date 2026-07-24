shader_type spatial;
render_mode cull_disabled, shadows_disabled;

uniform float bottom = 0.0f;
uniform float top = 1.0f;
uniform float glassThickness = 0.05f;
global uniform vec4 player1Color : source_color;
global uniform vec4 player2Color : source_color;

uniform float globalFill : hint_range(0.0, 1.0) = 0.5f;
uniform float sideBias: hint_range(0.0, 1.0) = 0.5f;

uniform float uv_scale : hint_range(0.001, 5);
uniform sampler2D texture_normal : hint_roughness_normal, filter_linear_mipmap, repeat_enable;
uniform float normal_depth : hint_range(0, 5);
uniform float normal_brightness_min : hint_range(0.0, 1.0) = 0.3;
uniform float normal_brightness_power : hint_range(0.1, 5.0) = 1.0;
uniform float normal_color_effect : hint_range(0.0, 1.0);
varying vec3 vPos;
void vertex()
{
	VERTEX -= NORMAL * glassThickness;
	vPos = VERTEX;
}

void fragment() 
{
	vec2 base_uv = UV * uv_scale;
	float midLine = 0.5 * (top - bottom) + bottom;
	float bottomFill = (midLine - bottom) * globalFill * (1.0f-sideBias);
	float topFill = (top - midLine) * globalFill * sideBias + midLine;
	float fillLine = (top - bottom) * globalFill ;
	// Position from 0 to 1 (similar to fill)
	float relativePos =(vPos.y -bottom)  / (top - bottom);
	vec3 normal = texture(texture_normal, base_uv).rgb * 2.0 - 1.0;

// Normalize in case the normal map isn't perfectly normalized
normal = normalize(normal);

// Calculate how much the normal points in the chosen direction
float normal_brightness = dot(
    normal,
    vec3(0.0,1.0,0.0)
);

// Remap [-1, 1] to [0, 1]
normal_brightness = normal_brightness * 0.5 + 0.5;

// Adjust contrast/falloff
normal_brightness = pow(normal_brightness, normal_brightness_power);

// Map to desired brightness range
float brightness = mix(
    normal_brightness_min,
    1,
    normal_brightness
);

if(vPos.y > midLine){
		ALBEDO = player1Color.rgb;
		if(vPos.y > topFill) discard;
	}
	else{
		ALBEDO = player2Color.rgb;
		if(vPos.y > bottomFill) discard;
	}
	ALBEDO *= brightness;
	if (!FRONT_FACING)
	{
		NORMAL = vec3(0, 1.0,0);
	}
	NORMAL_MAP = texture(texture_normal, base_uv).rgb;
	NORMAL_MAP_DEPTH = normal_depth;
}