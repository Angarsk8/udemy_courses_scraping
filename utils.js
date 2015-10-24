function getUrls() {
    return $(".course-box-flat").map(function() {
            return $(this)
                .find("a")
                .attr("href");
        })
        .toArray();
}

var arrayOfPaths = [];
arrayOfPaths = arrayOfPaths.concat(getUrls());