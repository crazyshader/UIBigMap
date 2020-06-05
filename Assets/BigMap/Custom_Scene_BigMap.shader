Shader "Custom/Scene/BigMap"
{
	Properties
	{
		_MainTexture("Main Texture", 2D) = "white" {}
		_MaskTexture("Mask Texture", 2D) = "white" {}
		_Fuzziness("Fuzziness", Range(0, 1)) = 1
		[HDR]_MaskColor("Mask Color", Color) = (1,1,1,1)
		[HDR]_HighlightColor("Highlight Color", Color) = (1,1,1,1)
		[HDR]_OutlineColor("Outline Color", Color) = (1,1,1,1)
		[HideInInspector]_BlockSelectIndex("Color Block Index", Float) = 0
	}
	
	SubShader
	{
		Tags { "Queue"="Transparent" "RenderType"="Transparent" "DisableBatching"="False" "ForceNoShadowCasting"="False" "IgnoreProjector"="True" "CanUseSpriteAtlas"="False" "PreviewType"="Plane" }
		LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha , SrcAlpha OneMinusSrcAlpha
		BlendOp Add , Add
		Cull Back
		ColorMask RGBA
		ZWrite Off
		ZTest Always
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="Always" }
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 uv_texcoord : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 uv_texcoord : TEXCOORD0;
			};

			uniform sampler2D _MainTexture;
			uniform float4 _MainTexture_ST;
			uniform sampler2D _MaskTexture;
			uniform float4 _MaskTexture_ST;
			uniform float _Fuzziness;
			uniform float4 _MaskColor;
			uniform float4 _HighlightColor;
			uniform float4 _OutlineColor;
			uniform float _BlockSelectIndex;
			uniform float4 _BlockColors[9];
			uniform float _BlockHighlights[9];

			v2f vert ( appdata v )
			{
				v2f o;

				o.uv_texcoord.xy = v.uv_texcoord.xy;				
				o.uv_texcoord.zw = 0;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				// block highlight
				float2 uv_MainTexture = i.uv_texcoord.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
				float4 MainTexture = tex2D( _MainTexture, uv_MainTexture );
				float blockHighlight0 = (_BlockHighlights[0] != 0) ? step( _Fuzziness , ( 1.0 - saturate(distance( MainTexture.rgb, _BlockColors[0].rgb ) ) )) : 0.0;
				float blockHighlight1 = (_BlockHighlights[1] != 0) ? step( _Fuzziness , ( 1.0 - saturate(distance( MainTexture.rgb, _BlockColors[1].rgb ) ) )) : 0.0;
				float blockHighlight2 = (_BlockHighlights[2] != 0) ? step( _Fuzziness , ( 1.0 - saturate(distance( MainTexture.rgb, _BlockColors[2].rgb ) ) )) : 0.0;
				float blockHighlight3 = (_BlockHighlights[3] != 0) ? step( _Fuzziness , ( 1.0 - saturate(distance( MainTexture.rgb, _BlockColors[3].rgb ) ) )) : 0.0;
				float blockHighlight4 = (_BlockHighlights[4] != 0) ? step( _Fuzziness , ( 1.0 - saturate(distance( MainTexture.rgb, _BlockColors[4].rgb ) ) )) : 0.0;
				float blockHighlight5 = (_BlockHighlights[5] != 0) ? step( _Fuzziness , ( 1.0 - saturate(distance( MainTexture.rgb, _BlockColors[5].rgb ) ) )) : 0.0;
				float blockHighlight6 = (_BlockHighlights[6] != 0) ? step( _Fuzziness , ( 1.0 - saturate(distance( MainTexture.rgb, _BlockColors[6].rgb ) ) )) : 0.0;
				float blockHighlight7 = (_BlockHighlights[7] != 0) ? step( _Fuzziness , ( 1.0 - saturate(distance( MainTexture.rgb, _BlockColors[7].rgb ) ) )) : 0.0;
				float blockHighlight8 = (_BlockHighlights[8] != 0) ? step( _Fuzziness , ( 1.0 - saturate(distance( MainTexture.rgb, _BlockColors[8].rgb ) ) )) : 0.0;
				float blockHighlight = (blockHighlight0 == 0 && blockHighlight1 == 0 && blockHighlight2 == 0 && blockHighlight3 == 0 && blockHighlight4 == 0 
					&& blockHighlight5 == 0	&& blockHighlight6 == 0 && blockHighlight7 == 0 && blockHighlight8 == 0) ? 0 : 1;
				fixed4 highlightColor = lerp(_MaskColor, _HighlightColor, blockHighlight);
				blockHighlight = step( _Fuzziness , ( 1.0 - saturate(distance( MainTexture.rgb, _BlockColors[_BlockSelectIndex].rgb ) ) ));
				highlightColor = lerp(highlightColor, fixed4(0, 0, 0, 0), blockHighlight);

				// block select
				float blockSelect = 0;
				float4 MaskTexture = tex2D( _MaskTexture, uv_MainTexture );
				blockSelect = (_BlockSelectIndex == 0 && uv_MainTexture.x < 0.459) ?  MaskTexture.r : blockSelect;
				blockSelect = (_BlockSelectIndex == 1 && uv_MainTexture.x < 0.635) ?  MaskTexture.g : blockSelect;
				blockSelect = (_BlockSelectIndex == 2 && uv_MainTexture.x > 0.459) ?  MaskTexture.r : blockSelect;
				blockSelect = (_BlockSelectIndex == 3 && uv_MainTexture.x > 0.635) ?  MaskTexture.g : blockSelect;
				blockSelect = (_BlockSelectIndex == 4 && uv_MainTexture.x < 0.356) ?  MaskTexture.b : blockSelect;
				blockSelect = (_BlockSelectIndex == 5 && uv_MainTexture.x < 0.439) ?  MaskTexture.a : blockSelect;
				blockSelect = (_BlockSelectIndex == 7 && uv_MainTexture.x > 0.356) ?  MaskTexture.b : blockSelect;
				blockSelect = (_BlockSelectIndex == 8 && uv_MainTexture.x > 0.439) ?  MaskTexture.a : blockSelect;
				blockSelect = (_BlockSelectIndex == 6) ?  MainTexture.a : blockSelect;
				fixed4 outlineColor = blockSelect *  _OutlineColor;

				fixed4 finalColor = highlightColor + outlineColor;
				return finalColor;
			}
			ENDCG
		}
	}	
}
