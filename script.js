function adjustFontSize(selector, amount, initial) {
		document.querySelectorAll(selector).forEach(element => {
				var estilo = element.style["font-size"];
				if (estilo == "") {
						estilo = initial;
				}
				element.style["font-size"] = parseFloat(estilo.slice(0,-2)) + amount
		});
}

function increaseFontSize(selector, amount, initial) {
		adjustFontSize(selector, amount, initial);
}

function decreaseFontSize(selector, amount, initial) {
		adjustFontSize(selector, 0 - amount, initial);
}

function initialize(config) {
		const div = document.createElement("div");
		div.style["position"] = "fixed";
		div.style["left"] = 10;
		div.style["bottom"] = 10;
		div.style["display"] = "grid";
		div.style["grid-template-columns"] = "repeat(3, 1fr)";
		div.style["z-index"] = 99;
		div.style["width"] = config.width;
		div.style["height"] = config.height;
		div.style["background-color"] = "green";
		div.style["color"] = "black";

		const showButton = document.createElement("button");
		showButton.innerHTML = "show";
		showButton.onclick = function(){
				div.style["opacity"] = 1.0;
		};

		const spacer = document.createElement("div");
		
		const hideButton = document.createElement("button");
		hideButton.innerHTML = "hide";
		hideButton.onclick = function(){
				div.style["opacity"] = 0.5;
		};

		div.appendChild(spacer);
		div.appendChild(showButton);
		div.appendChild(hideButton);

		for (let i = 0; i < config.adjusters.length; i++) {
				let thing = config.adjusters[i];
				const text = document.createElement("p");
				text.style["font-size"] = "1.0em";
				text.innerHTML = thing["displayName"];

				div.appendChild(text);

				const buttonIncrement = document.createElement("button");
				buttonIncrement.style["font-size"] = "1.0em";
				buttonIncrement.innerHTML = "+";
				buttonIncrement.onclick = function(){increaseFontSize(thing["selector"], thing["interval"], thing["defaultSize"])};
				div.appendChild(buttonIncrement);

				const buttonDecrement = document.createElement("button");
				buttonDecrement.style["font-size"] = "1.0em";
				buttonDecrement.innerHTML = "-";
				buttonDecrement.onclick = function(){decreaseFontSize(thing["selector"], thing["interval"], thing["defaultSize"])};
				div.appendChild(buttonDecrement);
		}

		document.body.appendChild(div);
}

let config = {
		width: "300px",
		height: "200px",
		fontSize: "1em",
		adjusters: [
				{
						displayName: "header",
						selector: "h1",
						defaultSize: "32px",
						unit: "px",
						interval: 2
				},
				{
						displayName: "section",
						selector: "h2",
						defaultSize: "24px",
						unit: "px",
						interval: 2
				},
				{
						displayName: "sub-section",
						selector: "h3",
						defaultSize: "18.72px",
						unit: "px",
						interval: 2
				},
				{
						displayName: "sub-sub-section",
						selector: "h4",
						defaultSize: "16px",
						unit: "px",
						interval: 0.25
				},
				{
						displayName: "sub-section",
						selector: "h3",
						defaultSize: "1.17em",
						unit: "px",
						interval: 0.25
				},
				{
						displayName: "italics",
						selector: "i",
						defaultSize: "20px",
						unit: "px",
						interval: 0.25
				},
				{
						displayName: "text",
						selector: "li",
						defaultSize: "14px",
						unit: "px",
						interval: 0.25
				}
		]
};

initialize(config);
