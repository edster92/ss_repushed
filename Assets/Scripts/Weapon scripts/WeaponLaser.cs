using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WeaponLaser : BaseWeapon
{
	
	[SerializeField]
	LineRenderer laserBeam;
	[SerializeField]
	ParticleSystem impactParticle;
	[SerializeField]
	LayerMask layer;

	public override void FireStart ()
	{

		laserBeam.gameObject.SetActive (true);
		base.FireStart ();
	}

	protected override IEnumerator Fire ()
	{
		while (fireOn) {
			RaycastHit hit;
			if (Physics.Raycast (laserBeam.transform.position, laserBeam.transform.forward, out hit, 122, layer)) 
			{
				laserBeam.SetPosition (1, (hit.point.z - laserBeam.transform.position.z) * Vector3.forward);
				hit.collider.gameObject.GetComponent<BasedGameObjects> ().AddedGamage (damage [WeaponLevel - 1] * Time.deltaTime);
				impactParticle.transform.position = laserBeam.transform.position + laserBeam.GetPosition (1);
					if (!impactParticle.isPlaying)
						impactParticle.Play (true);
			} 
			else 
			{
				laserBeam.SetPosition (1, 122 * Vector3.forward);
				if (impactParticle.isPlaying)
					impactParticle.Stop ();
			}
			yield return null;
		}
	}
	public override void FireEnd ()
	{
		base.FireEnd ();
		laserBeam.gameObject.SetActive (false);
		impactParticle.Stop ();
	}
}
