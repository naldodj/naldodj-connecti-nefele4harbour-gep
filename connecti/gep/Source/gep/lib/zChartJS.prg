#include "Xailer.ch"
#include "Nefele.ch"

class zChartJS from WBevel

   PROPERTY cClassId INIT "chartjs"
   PROPERTY cClass   INIT "chartjs"

    PROPERTY cType
    PROPERTY cID
    PROPERTY cLabels
    PROPERTY cLabel
    PROPERTY cBackColor
    PROPERTY cData
    PROPERTY cTitle
    PROPERTY cWidth
    PROPERTY cHeight

    method New(oParent)
    method create

end class

method New(oParent) class zChartJS
return( ::Super:New( oParent ) )

method Create() class zChartJS

   local cHTMLChart

   WITH OBJECT ::oHtml
      AAdd( :aHeadLinks, cInHeadzChartJS() )
	END

   cHTMLChart:=PlotChart(::cType,::cID,::cLabels,::cLabel,::cBackColor,::cData,::cTitle,::cWidth,::cHeight)
   ::Super:oParent:AddHTML( cHTMLChart )

return( ::Super:Create() )

static function PlotChart(cType,cID,cLabels,cLabel,cBackColor,cData,cTitle,cWidth,cHeight)

   local cChart

   TEXT INTO cChart
   <div align="center">
        <canvas id="@cID@" width="@cWidth@" height="@cHeight@"></canvas>
        <script>
           //chart
                var objIDCanvas = document.getElementById("@cID@");
                var @cID@ = new Chart(objIDCanvas,
                {
                    type: "@cType@",
                    data: {
                      labels: @cLabels@,
                      datasets: [
                        {
                          label: "@cLabel@",
                          backgroundColor: @cBackColor@,
                          borderColor: @cBackColor@,
                          borderWidth: 1,
                          data: @cData@
                        }
                      ]
                    },
                    options: {
                        legend: { display: false },
                        title: {
                            display: false,
                            text: '@cTitle@'
                        },
                        scales: {
            y: {
                suggestedMin: 100,
                suggestedMax: 1000000
            }
        }
                    }
                 }
            );
        </script>
    </div>
    ENDTEXT

    HB_Default(@cType,"bar")
    cChart:=StrTran(cChart,"@cType@",cType)

    HB_Default(@cWidth,"400")
    cChart:=StrTran(cChart,"@cWidth@",cWidth)

    HB_Default(@cHeight,"100")
    cChart:=StrTran(cChart,"@cHeight@",cHeight)

    HB_Default(@cID,"char-"+cType)
    cChart:=StrTran(cChart,"@cID@",cID+__AutoID())

    HB_Default(@cLabels,"['x','y']")
    cChart:=StrTran(cChart,"@cLabels@",cLabels)

    HB_Default(@cLabel,"char-"+cType)
    cChart:=StrTran(cChart,"@cLabel@",cLabel)

    HB_Default(@cBackColor,"["+RGBToHTML(rgb(hb_RandomInt(0,255),hb_RandomInt(0,255),hb_RandomInt(0,255)))+","+RGBToHTML(rgb(hb_RandomInt(0,255),hb_RandomInt(0,255),hb_RandomInt(0,255)))+"]")
    cChart:=StrTran(cChart,"@cBackColor@",cBackColor)

    HB_Default(@cData,"[10,20]")
    cChart:=StrTran(cChart,"@cData@",cData)

    HB_Default(@cData,"char-"+cType)
    cChart:=StrTran(cChart,"@cTitle@",cTitle)

    return(cChart)

static function cInHeadzChartJS()
   LOCAL cInHead
   TEXT INTO cInHead
<script src='https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.5.0/Chart.min.js'></script>
   ENDTEXT
    return(cInHead)