using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIprogressBar : MonoBehaviour {


	float curentValue;
	public float CurrentValue {
		get {return curentValue; }
		set {if (curentValue != value) {
				Vector3 ls = progressBar.localScale;
				ls.y = value;
				progressBar.localScale = ls;
				curentValue = value;
			}
		}
	}

	[SerializeField]
	Transform progressBar;


	public GameObject icon;




}
