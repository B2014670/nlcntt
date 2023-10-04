const fileUpload = document.querySelector(".custom-file-input");
fileUpload.addEventListener("change", (event) => {
	const { files } = event.target;
	// console.log("files",files);
	document.querySelector(".custom-file-label").innerHTML = files[0].name;

})