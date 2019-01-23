using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[System.Serializable]
public class BonusContainer
{
    public int BonusQuantity;
    public ChoseBonusType BonusType;
	public BaseWeapon.weaponTypes WeaponType;
    public enum ChoseBonusType
    {
        HelathPonts,
        Weapon,
        Immortality,
		GreatBaBah
    };
    public BonusContainer (int bonusQuantity, ChoseBonusType bonusType)
    {
        BonusQuantity = bonusQuantity;
        BonusType = bonusType;
    }
}

