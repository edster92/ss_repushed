// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "fx/Distrort_wave"
{
	Properties
	{
		_Normal("Normal", 2D) = "bump" {}
		_NormalScale("NormalScale", Float) = 0
		_Light("Light", 2D) = "white" {}
		_Color("Color", Color) = (0.1839623,0.7583485,1,0)
		_MaskPower("MaskPower", Float) = 1
		_MAskIntense("MAskIntense", Float) = 1
		_ColorIntense("ColorIntense", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		GrabPass{ }
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float _ColorIntense;
		uniform float4 _Color;
		uniform sampler2D _GrabTexture;
		uniform float _NormalScale;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Light;
		uniform float4 _Light_ST;
		uniform float _MAskIntense;
		uniform float _MaskPower;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 appendResult7 = (float2(ase_grabScreenPosNorm.r , ase_grabScreenPosNorm.g));
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float4 screenColor3 = tex2D( _GrabTexture, ( float3( ( appendResult7 / ase_grabScreenPosNorm.a ) ,  0.0 ) + UnpackScaleNormal( tex2D( _Normal, uv_Normal ), _NormalScale ) ).xy );
			o.Emission = ( _ColorIntense * ( _Color + screenColor3 ) ).rgb;
			float2 uv_Light = i.uv_texcoord * _Light_ST.xy + _Light_ST.zw;
			o.Alpha = ( pow( ( tex2D( _Light, uv_Light ).r * _MAskIntense ) , _MaskPower ) * i.vertexColor.a );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15800
6.4;0.8;1523;795;1675.712;339.9583;1.750188;True;True
Node;AmplifyShaderEditor.GrabScreenPosition;4;-1226.46,-111.6024;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;7;-981.3502,-82.44314;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1255.362,186.5631;Float;False;Property;_NormalScale;NormalScale;1;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-985.9122,74.43934;Float;True;Property;_Normal;Normal;0;0;Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;8;-809.4506,-37.31787;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;29;-1237.055,371.2838;Float;True;Property;_Light;Light;3;0;Create;True;0;0;False;0;5228a04ef529d2641937cab585cc1a02;e1325dac1e127af4aa74454139d19296;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;36;-1117.401,567.5144;Float;False;Property;_MAskIntense;MAskIntense;6;0;Create;True;0;0;False;0;1;1.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-499.101,44.69077;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-972.1367,761.785;Float;False;Property;_MaskPower;MaskPower;5;0;Create;True;0;0;False;0;1;2.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;33;-450.5804,-177.1907;Float;False;Property;_Color;Color;4;0;Create;True;0;0;False;0;0.1839623,0.7583485,1,0;0,0.5937939,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;3;-365.002,38.99625;Float;False;Global;_GrabScreen0;Grab Screen 0;1;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-916.1303,376.7437;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;31;-468.0815,458.1274;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;38;-699.1076,373.2436;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-153.0487,-128.1855;Float;False;Property;_ColorIntense;ColorIntense;7;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-147.798,-21.42398;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;18;-1498.971,1.558347;Float;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;17;-1220.268,54.97663;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1453.97,117.1349;Float;False;Property;_Speed;Speed;2;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;48.2229,-37.17576;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-273.8105,340.8647;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;289.9337,127.2025;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;fx/Distrort_wave;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;4;1
WireConnection;7;1;4;2
WireConnection;1;5;9;0
WireConnection;8;0;7;0
WireConnection;8;1;4;4
WireConnection;5;0;8;0
WireConnection;5;1;1;0
WireConnection;3;0;5;0
WireConnection;35;0;29;1
WireConnection;35;1;36;0
WireConnection;38;0;35;0
WireConnection;38;1;37;0
WireConnection;34;0;33;0
WireConnection;34;1;3;0
WireConnection;17;0;18;0
WireConnection;17;2;19;0
WireConnection;40;0;39;0
WireConnection;40;1;34;0
WireConnection;32;0;38;0
WireConnection;32;1;31;4
WireConnection;0;2;40;0
WireConnection;0;9;32;0
ASEEND*/
//CHKSM=E1E983415D2E9705FF4C349C779BA5D625F05BFC