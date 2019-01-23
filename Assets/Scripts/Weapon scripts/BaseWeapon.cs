using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BaseWeapon : MonoBehaviour 
{
	public int WeaponLevel = 1;
	public int MaxWeaponLevel = 3;
	[SerializeField]
	protected GameObject bulletSample;
	[SerializeField]
	protected float [] fireRate;
	protected float lastFireTime;
	public bool fireOn = false;
	[SerializeField]
	protected WeaponsShotAnchors [] levelAnchors;
	[SerializeField]
	public float [] damage;
	public weaponTypes Type;
	public enum weaponTypes 
	{
		Laser,
		MultiShot,
		SingleShot
	}

	public virtual void FireStart ()
	{
		fireOn = true;
		StartCoroutine (Fire ());
	}

	protected virtual IEnumerator Fire ()
	{
		yield return null;
	}

	public virtual void FireEnd ()
	{
		StopCoroutine (Fire ());
		fireOn = false;
	}

	public virtual void WeaponLevelsUp ()
	{
		WeaponLevel++;
	}

	public virtual void WeaponReset ()
	{
		WeaponLevel = 1;
	}


}
