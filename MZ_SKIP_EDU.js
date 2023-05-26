var content = top.contentFrame

var progress = null;
var btn = null;
var curPage = null;
var totalPage = null;

var all = content.document.getElementsByTagName("*");
for (var i=0, max=all.length; i < max; i++) {
	progress = content.document.getElementsByClassName("vjs-progress-holder vjs-slider vjs-slider-horizontal")[0]
	btn = content.document.getElementsByClassName("btn next")[0]
}
var nav = content.document.getElementsByClassName("nav");
for (var i=0, max=nav.length; i < max; i++) {
	curPage = nav[0].getElementsByClassName("current")[0]
	totalPage = nav[0].getElementsByClassName("total")[0]
}
console.log("find all done")

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

var bLoop = false;
async function AutoClick() {
	bLoop = true;
	while(bLoop) {
		if(curPage.outerText < totalPage.outerText) {
			console.log("진행도:", progress.ariaValueNow)
			if(progress.ariaValueNow >= 100.0) {
				btn.click()
				console.log("click!")
				await sleep(6000)
			}
			await sleep(2000)
		}
        else if(curPage.outerText == totalPage.outerText) {
            if(progress.ariaValueNow >= 100.0) {
                StopAutoClick()
                break // actually no need break, cause call StopAutoClick function above.
            }
        }
	}
}

function StopAutoClick() {
	bLoop = false;
}

AutoClick();
