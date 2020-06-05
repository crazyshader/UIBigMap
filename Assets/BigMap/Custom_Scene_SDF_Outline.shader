// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Scene/Custom_Scene_SDF_Outline"
{
	Properties
	{
		_MapTexture("Map Texture", 2D) = "white" {}
		_SDFTexture("SDF Texture", 2D) = "white" {}
		_EdgeAlpha("Edge Alpha", Range( 0 , 1)) = 1
		_OuterEdge("Outer Edge", Range( 0 , 1)) = 1
		_OuterFalloff("Outer Falloff", Range( 0 , 1)) = 1
		_OuterGlowColor("Outer Glow Color", Color) = (0,0.2396581,1,1)
		_InnerEdge("Inner Edge", Range( 0 , 1)) = 0
		_InnerFalloff("Inner Falloff", Range( 0 , 1)) = 0
		_InnerGlowColor("Inner Glow Color", Color) = (0,0,0,0)
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

			uniform float4 _OuterGlowColor;
			uniform float _OuterEdge;
			uniform float _EdgeAlpha;
			uniform float _OuterFalloff;
			uniform sampler2D _SDFTexture;
			uniform float4 _SDFTexture_ST;
			uniform sampler2D _MapTexture;
			uniform float4 _MapTexture_ST;
			uniform float4 _InnerGlowColor;
			uniform float _InnerEdge;
			uniform float _InnerFalloff;

			
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
				float _EdgeAlpha39 = _EdgeAlpha;
				float temp_output_17_0 = ( ( 1.0 - _OuterEdge ) * _EdgeAlpha39 );
				float lerpResult18 = lerp( temp_output_17_0 , _EdgeAlpha39 , _OuterFalloff);
				float2 uv_SDFTexture = i.ase_texcoord.xy * _SDFTexture_ST.xy + _SDFTexture_ST.zw;
				float _SDFTexture47 = tex2D( _SDFTexture, uv_SDFTexture ).a;
				float smoothstepResult20 = smoothstep( temp_output_17_0 , lerpResult18 , _SDFTexture47);
				float4 appendResult23 = (float4(1.0 , 1.0 , 1.0 , smoothstepResult20));
				float2 uv_MapTexture = i.ase_texcoord.xy * _MapTexture_ST.xy + _MapTexture_ST.zw;
				float4 _MainTexture57 = tex2D( _MapTexture, uv_MapTexture );
				float4 lerpResult32 = lerp( float4( 0,0,0,0 ) , _OuterGlowColor , _MainTexture57.a);
				float lerpResult43 = lerp( _InnerEdge , 1.0 , _EdgeAlpha39);
				float lerpResult45 = lerp( lerpResult43 , _EdgeAlpha39 , _InnerFalloff);
				float smoothstepResult50 = smoothstep( lerpResult45 , lerpResult43 , _SDFTexture47);
				float4 lerpResult56 = lerp( _InnerGlowColor , _MainTexture57 , max( smoothstepResult50 , ( 1.0 - _InnerGlowColor.a ) ));
				float4 break61 = lerpResult56;
				float4 appendResult64 = (float4(break61.r , break61.g , break61.b , 1.0));
				float4 lerpResult70 = lerp( ( ( _OuterGlowColor * appendResult23 ) - lerpResult32 ) , appendResult64 , step( _EdgeAlpha39 , _SDFTexture47 ));
				
				
				finalColor = lerpResult70;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18000
1903;31;1815;968;2293.411;2154.846;2.924646;True;False
Node;AmplifyShaderEditor.CommentaryNode;71;-552.0669,-1862.984;Inherit;False;2049.617;286.3584;Input;6;16;39;36;47;2;57;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-502.0669,-1778.182;Inherit;False;Property;_EdgeAlpha;Edge Alpha;2;0;Create;True;0;0;False;0;1;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;-171.1384,-1776.657;Inherit;False;_EdgeAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;46;-614.1369,-1189.866;Inherit;False;962.3781;356.5708;Remap Inner Edges;5;41;45;42;43;44;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;37;-326.2631,-93.4233;Inherit;False;1001.78;418.9246;Remap Outer Edges;6;14;15;19;17;18;40;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-306.5486,-43.42334;Inherit;False;Property;_OuterEdge;Outer Edge;3;0;Create;True;0;0;False;0;1;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;36;233.4138,-1812.984;Inherit;True;Property;_SDFTexture;SDF Texture;1;0;Create;True;0;0;False;0;-1;None;83ab63016c57e3a43a529bd503d754aa;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;42;-564.1368,-997.4205;Inherit;False;Property;_InnerEdge;Inner Edge;6;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;-495.8463,-1106.158;Inherit;False;39;_EdgeAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;65;398.6861,-1231.814;Inherit;False;1470.734;568.8038;Inner Glow / Inline;9;50;53;55;60;56;61;64;51;52;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;43;-76.65401,-989.2957;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-193.899,-1139.866;Inherit;False;Property;_InnerFalloff;Inner Falloff;7;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;591.585,-1720.402;Inherit;False;_SDFTexture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;-35.48912,99.62444;Inherit;False;39;_EdgeAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;15;15.73376,-39.93677;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;894.5443,-1806.626;Inherit;True;Property;_MapTexture;Map Texture;0;0;Create;True;0;0;False;0;-1;4228c50f2bee4354ea7dcd9f793c326b;2f25c0037eb18a54abe2e3fe4c67f2a7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;51;448.6861,-1181.814;Inherit;False;47;_SDFTexture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;52;458.9959,-870.3137;Inherit;False;Property;_InnerGlowColor;Inner Glow Color;8;0;Create;True;0;0;False;0;0,0,0,0;1,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;45;164.2414,-1121.216;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;90.18246,210.5011;Inherit;False;Property;_OuterFalloff;Outer Falloff;4;0;Create;True;0;0;False;0;1;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;218.4955,15.03462;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;38;738.9304,-430.3177;Inherit;False;1130.055;578.3508;Outer Glow / Outline;8;20;23;24;25;34;32;58;59;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SmoothstepOpNode;50;703.8253,-1031.612;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;356.2855,-50.27186;Inherit;False;47;_SDFTexture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;18;403.5445,82.2855;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;57;1254.55,-1806.195;Inherit;False;_MainTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;53;721.803,-773.0099;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;20;906.2451,37.15076;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;762.079,-386.947;Inherit;False;57;_MainTexture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;55;923.706,-918.2141;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;832.827,-1176.943;Inherit;False;57;_MainTexture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;56;1171.245,-915.4484;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;58;995.0989,-381.2006;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ColorNode;24;1064.013,-227.7555;Inherit;False;Property;_OuterGlowColor;Outer Glow Color;5;0;Create;True;0;0;False;0;0,0.2396581,1,1;0,0.2396581,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;23;1136.612,-30.96691;Inherit;False;FLOAT4;4;0;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;32;1329.412,-356.9177;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;1525.434,-524.5435;Inherit;False;47;_SDFTexture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;1332.049,-59.16446;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;61;1384.42,-915.9432;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;69;1530.996,-610.8204;Inherit;False;39;_EdgeAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;34;1633.986,-196.5305;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;68;1763.459,-580.9326;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;64;1702.42,-916.9432;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;70;2016.375,-626.5762;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;2218.119,-626.7158;Float;False;True;-1;2;ASEMaterialInspector;100;11;Custom/Scene/BigMap1;5aedfe98c1bb53244884b66eb9151383;True;Unlit;0;0;Unlit;1;True;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;True;1;False;-1;1;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;7;False;-1;True;False;0;False;-1;0;False;-1;True;7;Queue=Transparent=Queue=0;RenderType=Transparent=RenderType;DisableBatching=False;ForceNoShadowCasting=False;IgnoreProjector=True;CanUseSpriteAtlas=False;PreviewType=Plane;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=Always;False;0;;0;0;Standard;0;0;1;True;False;;0
WireConnection;39;0;16;0
WireConnection;43;0;42;0
WireConnection;43;2;41;0
WireConnection;47;0;36;4
WireConnection;15;0;14;0
WireConnection;45;0;43;0
WireConnection;45;1;41;0
WireConnection;45;2;44;0
WireConnection;17;0;15;0
WireConnection;17;1;40;0
WireConnection;50;0;51;0
WireConnection;50;1;45;0
WireConnection;50;2;43;0
WireConnection;18;0;17;0
WireConnection;18;1;40;0
WireConnection;18;2;19;0
WireConnection;57;0;2;0
WireConnection;53;0;52;4
WireConnection;20;0;48;0
WireConnection;20;1;17;0
WireConnection;20;2;18;0
WireConnection;55;0;50;0
WireConnection;55;1;53;0
WireConnection;56;0;52;0
WireConnection;56;1;60;0
WireConnection;56;2;55;0
WireConnection;58;0;59;0
WireConnection;23;3;20;0
WireConnection;32;1;24;0
WireConnection;32;2;58;3
WireConnection;25;0;24;0
WireConnection;25;1;23;0
WireConnection;61;0;56;0
WireConnection;34;0;25;0
WireConnection;34;1;32;0
WireConnection;68;0;69;0
WireConnection;68;1;66;0
WireConnection;64;0;61;0
WireConnection;64;1;61;1
WireConnection;64;2;61;2
WireConnection;70;0;34;0
WireConnection;70;1;64;0
WireConnection;70;2;68;0
WireConnection;1;0;70;0
ASEEND*/
//CHKSM=AE7D97ED83EEDC7BE529F3480C4E5C773459C6EC