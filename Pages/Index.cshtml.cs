using Microsoft.ApplicationInsights;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace appinsights_webapp.Pages;

public class IndexModel : PageModel
{
    private readonly TelemetryClient _tc;
    private readonly ILogger<IndexModel> _logger;

    public IndexModel(ILogger<IndexModel> logger, TelemetryClient tc ) => (_logger, _tc) = (logger, tc);

    public void OnGet()
    {
        _tc.TrackEvent("IndexModel_OnGet", new Dictionary<string, string> { { "Page", "Index" } });
        try
        {
            throw new NullReferenceException("This is a test exception");
        }
        catch (Exception e)
        {
            _logger.LogError(e, "An error occurred in the IndexModel_OnGet method");
        }
    }
}
