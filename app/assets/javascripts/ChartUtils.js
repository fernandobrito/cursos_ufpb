(function (expose) {
    var ChartUtils = {};

    // http://there4.io/2012/05/02/google-chart-color-list/
    ChartUtils.SITUATIONS_COLORS = {
        'APROVADO': '#3366CC',    // Default blue
        'REPROVADO': '#DC3912',   // Default red
        'MATRICULADO': '#109618', // Green
        'TRANCADO': '#949BA2',    // Gray
        'DISPENSADO': '#0099C6',  // Light blue
        'REP. FALTA': '#8B0707'   // Wine (dark red)
    };

    ChartUtils.getSituationsColors = function (situations) {
        var colors = [];
        situations.forEach(function (situation) {
           colors.push(ChartUtils.SITUATIONS_COLORS[situation]);
        });
        return colors;
    };

    expose.ChartUtils = ChartUtils;
})(window);
