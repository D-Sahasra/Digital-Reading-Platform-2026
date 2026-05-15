function saveItem(event) {
		 event.preventDefault();

		    fetch("session-status.jsp", { cache: "no-store" })
		        .then(function(response) {
		        	if (!response.ok) {
		                throw new Error("HTTP error");
		            }
		            return response.json();
		        })
		        .then(function(data) {
		            var isLoggedIn = (data.loggedIn === true || data.loggedIn === "true");
		            if (!isLoggedIn) {
		                alert("You can only save when you login.");
		                return;
		            }
    const itemId = new URLSearchParams(window.location.search).get('id') || "1";
    let saved = JSON.parse(localStorage.getItem("savedItems")) || [];
    
    if (!saved.includes(itemId)) {
        saved.push(itemId);
        localStorage.setItem("savedItems", JSON.stringify(saved));
        alert("Saved successfully!");
    } else {
        alert("Already saved!");
    }
  })
	  .catch(function() {
		    alert("Could not check login status.");
		        });

		    return false;
		}


