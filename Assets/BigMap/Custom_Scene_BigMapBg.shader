// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Scene/BigMapBg"
{
	Properties
	{
		_MapTexture("Map Texture", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

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



#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
		//only defining to not throw compilation error over Unity 5.5
		#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			

			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
			};

			uniform sampler2D _MapTexture;
			uniform float4 _MapTexture_ST;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				float2 uv_MapTexture = i.ase_texcoord.xy * _MapTexture_ST.xy + _MapTexture_ST.zw;
				float4 tex2DNode2 = tex2D( _MapTexture, uv_MapTexture );
				
				
				finalColor = tex2DNode2;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18000
1937;102;1818;810;861.355;179.6766;1.3;True;False
Node;AmplifyShaderEditor.SamplerNode;2;-267.5,126.5;Inherit;True;Property;_MapTexture;Map Texture;0;0;Create;True;0;0;False;0;-1;None;f9279ef8e551cf349ac9f1b9df5c0e1d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;15;145.5152,49.9613;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LengthOpNode;10;386.285,205.0263;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;18;594.7682,185.3943;Inherit;False;2;0;FLOAT;0.1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;16;784.8904,55.3008;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;893.3354,433.4542;Float;False;True;-1;2;ASEMaterialInspector;100;11;Custom/Scene/BigMapBg;5aedfe98c1bb53244884b66eb9151383;True;Unlit;0;0;Unlit;1;True;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;True;1;False;-1;1;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;7;False;-1;True;False;0;False;-1;0;False;-1;True;7;Queue=Transparent=Queue=0;RenderType=Transparent=RenderType;DisableBatching=False;ForceNoShadowCasting=False;IgnoreProjector=True;CanUseSpriteAtlas=False;PreviewType=Plane;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=Always;False;0;;0;0;Standard;0;0;1;True;False;;0
WireConnection;15;0;2;0
WireConnection;10;0;15;0
WireConnection;18;1;10;0
WireConnection;16;0;15;0
WireConnection;16;3;18;0
WireConnection;1;0;2;0
ASEEND*/
//CHKSM=AFC931D9352C752727F1EFE54C680F0CAA8C5A9A