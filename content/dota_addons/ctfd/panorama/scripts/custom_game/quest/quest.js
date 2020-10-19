"use strict";
// Expects:
// 		score_obj = 
//		{
//			radi_score = int score
//			dire_score = int score
//		}


function HasFlag(WhoHasFlag)
{
	$( "#GoodFlag" ).html = true;
	if(WhoHasFlag.GoodHasFlag == 1)
	{
	WhoHasFlag.GoodHasFlag = "Bad Flag Is Captured!";
	$( "#GoodFlag" ).text = WhoHasFlag.GoodHasFlag.toString();
	//$( "#RadiantScoreLabel" ).text = score_obj.radi_score.toString();
	}
	
	if(WhoHasFlag.GoodHasFlag == 0)
	{
	WhoHasFlag.GoodHasFlag = "Bad Flag Not Captured";
	$( "#GoodFlag" ).text = WhoHasFlag.GoodHasFlag.toString();
	//$( "#RadiantScoreLabel" ).text = score_obj.radi_score.toString();
	}


	$( "#BadFlag" ).html = true;
	if(WhoHasFlag.BadHasFlag == 1)
	{
	WhoHasFlag.BadHasFlag = "Good Flag Is Captured!";
	$( "#BadFlag" ).text = WhoHasFlag.BadHasFlag.toString();
	//$( "#DireScoreLabel" ).text = score_obj.dire_score.toString();
	}
	if(WhoHasFlag.BadHasFlag == 0)
	{
	WhoHasFlag.BadHasFlag = "Good Flag Not Captured";
	$( "#BadFlag" ).text = WhoHasFlag.BadHasFlag.toString();
	//$( "#DireScoreLabel" ).text = score_obj.dire_score.toString();
	}

	//$( "#TeamScore" ).html = true;
	//$( "#TeamScore" ).text = score_obj.radi_score.toString();

	//$(DOTA_DEFAULT_UI_TOP_BAR_SCORE)

}


(function()
{
	GameEvents.Subscribe( "has_flag", HasFlag );
})();