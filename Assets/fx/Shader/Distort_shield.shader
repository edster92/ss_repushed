// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "fx/distrort_shield"
{
	Properties
	{
		_Normal("Normal", 2D) = "white" {}
		_SpeedDistort("SpeedDistort", Float) = 0
		_ColorIntense("ColorIntense", Float) = 0
		_PAnner2("PAnner2", Float) = 0.35
		_Color0("Color 0", Color) = (1,1,1,0)
		_Panner1("Panner1", Float) = -0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
			float4 vertexColor : COLOR;
		};

		uniform float _ColorIntense;
		uniform float4 _Color0;
		uniform float _Panner1;
		uniform float _PAnner2;
		uniform sampler2D _GrabTexture;
		uniform sampler2D _Normal;
		uniform float _SpeedDistort;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (_Panner1).xx;
			float2 panner45 = ( 1.0 * _Time.y * temp_cast_0 + i.uv_texcoord);
			float simplePerlin2D46 = snoise( panner45 );
			float2 temp_cast_1 = (_PAnner2).xx;
			float2 panner37 = ( 1.0 * _Time.y * temp_cast_1 + i.uv_texcoord);
			float simplePerlin2D38 = snoise( panner37 );
			float4 temp_output_52_0 = ( _ColorIntense * ( _Color0 * ( simplePerlin2D46 * simplePerlin2D38 ) ) );
			o.Albedo = temp_output_52_0.rgb;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float2 appendResult7 = (float2(ase_grabScreenPos.r , ase_grabScreenPos.g));
			float2 temp_cast_4 = (_SpeedDistort).xx;
			float2 panner17 = ( 1.0 * _Time.y * temp_cast_4 + i.uv_texcoord);
			float4 screenColor3 = tex2D( _GrabTexture, ( float4( ( appendResult7 / ase_grabScreenPos.a ), 0.0 , 0.0 ) + tex2D( _Normal, panner17 ) ).rg );
			o.Emission = ( temp_output_52_0 + screenColor3 ).rgb;
			o.Alpha = ( abs( _SinTime.w ) * i.vertexColor.a );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15800
6.4;0.8;1523;795;1744.783;208.5577;1.557131;True;True
Node;AmplifyShaderEditor.RangedFloatNode;43;-1587.072,-384.433;Float;False;Property;_PAnner2;PAnner2;5;0;Create;True;0;0;False;0;0.35;0.16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-1591.853,-460.9736;Float;False;Property;_Panner1;Panner1;7;0;Create;True;0;0;False;0;-0.5;1.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;18;-1814.699,-211.6611;Float;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GrabScreenPosition;4;-1226.46,-111.6024;Float;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;45;-1263.826,-424.0698;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;37;-1273.395,-316.7771;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1453.97,117.1349;Float;False;Property;_SpeedDistort;SpeedDistort;3;0;Create;True;0;0;False;0;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;17;-1220.268,54.97663;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;7;-981.3502,-82.44314;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;46;-1034.206,-573.7333;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;38;-1035.575,-331.1279;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;8;-809.4506,-37.31787;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-987.6624,74.43934;Float;True;Property;_Normal;Normal;1;0;Create;True;0;0;False;0;None;fdca8592bcf83d7489f3b374631c3f18;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-750.5972,-327.0278;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;48;-758.3051,-545.9046;Float;False;Property;_Color0;Color 0;6;0;Create;True;0;0;False;0;1,1,1,0;1,0.8431373,0,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-494.3219,-406.9848;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SinTimeNode;54;-1347.714,432.9803;Float;True;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-580.525,13.7612;Float;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-469.7198,-509.4944;Float;False;Property;_ColorIntense;ColorIntense;4;0;Create;True;0;0;False;0;0;0.81;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;56;-751.3336,584.022;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;31;-684.0021,321.3657;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;3;-417.7233,30.61874;Float;False;Global;_GrabScreen0;Grab Screen 0;1;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-305.7049,-349.5795;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-326.2372,439.2089;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;53;-144.0521,21.89798;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1255.362,186.5631;Float;False;Property;_NormalScale;NormalScale;2;0;Create;True;0;0;False;0;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;22.15494,11.69013;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;fx/distrort_shield;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;45;0;18;0
WireConnection;45;2;44;0
WireConnection;37;0;18;0
WireConnection;37;2;43;0
WireConnection;17;0;18;0
WireConnection;17;2;19;0
WireConnection;7;0;4;1
WireConnection;7;1;4;2
WireConnection;46;0;45;0
WireConnection;38;0;37;0
WireConnection;8;0;7;0
WireConnection;8;1;4;4
WireConnection;1;1;17;0
WireConnection;47;0;46;0
WireConnection;47;1;38;0
WireConnection;50;0;48;0
WireConnection;50;1;47;0
WireConnection;5;0;8;0
WireConnection;5;1;1;0
WireConnection;56;0;54;4
WireConnection;3;0;5;0
WireConnection;52;0;51;0
WireConnection;52;1;50;0
WireConnection;55;0;56;0
WireConnection;55;1;31;4
WireConnection;53;0;52;0
WireConnection;53;1;3;0
WireConnection;0;0;52;0
WireConnection;0;2;53;0
WireConnection;0;9;55;0
ASEEND*/
//CHKSM=3AB02A42FBB2F7F1E3792B3B70EA68AC84C6B3B5