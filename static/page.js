const search = document.getElementById('org-search');
const resultsContainer = document.getElementById('org-search-results');

if (search) {
    search.addEventListener('input', function () {
        const query = search.value
            .replace(/[^a-zA-Z0-9]/g, "")
            .toLowerCase();

        const children = resultsContainer.children;

        for (let i = 0; i < children.length; i++) {
            const orgName = children[i].id
                .replace(/[^a-zA-Z0-9]/g, "")
                .toLowerCase();

            if (orgName.includes(query)) {
                children[i].style.display = "";
            } else {
                children[i].style.display = "none";
            }
        }
    });
}

const fileInput = document.getElementById('report-file-selector');

if (fileInput) {
    const label = fileInput.parentElement;
    fileInput.addEventListener('change', function () {
        const file = fileInput.files[0];
        console.log("FILE");
        if (!file) return;

        const reader = new FileReader();
        reader.onload = function (e) {

            label.style.backgroundImage = `
    linear-gradient(rgba(255,255,255,0.6), rgba(255,255,255,0.6)),
    url(${e.target.result})
`;
            label.style.backgroundSize = 'cover';
            label.style.backgroundPosition = 'center';
            label.style.backgroundRepeat = 'no-repeat';
        };
        reader.readAsDataURL(file);
    });
}

const loginForm = document.getElementById("login");
if (loginForm) {

    const urlParams = new URLSearchParams(window.location.search);
    const returnTo = urlParams.get("returnto") || "/"; // fallback to /

    loginForm.addEventListener("submit", async (e) => {
        e.preventDefault(); // prevent default form submit

        const email = document.getElementById("email").value.trim();
        const password = document.getElementById("password").value.trim();

        console.log(email, password)

        if (!email || !password) {
            alert("Please enter both email and password.");
            return;
        }

        try {
            const response = await fetch(
                "http://localhost:8080/api/login?email=" + encodeURIComponent(email) +
                "&password=" + encodeURIComponent(password),
                {
                    method: "POST",
                    credentials: "include"
                }
            );

            if (!response.ok) {
                const errData = await response.json().catch(() => ({}));
                alert(errData.error || "Login failed");
                return;
            }

            const data = await response.json();

            if (data.success) {
                // Redirect to returnto param if provided
                window.location.href = returnTo;
            } else {
                alert(data.error || "Login failed");
            }

        } catch (err) {
            console.error("Login request failed:", err);
            alert("An error occurred. Please try again.");
        }
    });
}

const signupForm = document.getElementById("signup");
if (signupForm) {

    const urlParams = new URLSearchParams(window.location.search);
    const returnTo = urlParams.get("returnto") || "/"; // fallback to /

    signupForm.addEventListener("submit", async (e) => {
        e.preventDefault(); // prevent default form submit

        const email = document.getElementById("email").value.trim();
        const password = document.getElementById("password").value.trim();
        const name = document.getElementById("name").value.trim();

        console.log(email, password)

        if (!email || !password) {
            alert("Please enter both email and password.");
            return;
        }

        try {
            const response = await fetch(
                "http://localhost:8080/api/signup?email=" + encodeURIComponent(email) +
                "&password=" + encodeURIComponent(password) +
                "&name=" + encodeURIComponent(name),
                {
                    method: "POST",
                    credentials: "include"
                }
            );

            if (!response.ok) {
                const errData = await response.json().catch(() => ({}));
                alert(errData.error || "Signup failed");
                return;
            }

            const data = await response.json();

            if (data.success) {
                // Redirect to returnto param if provided
                window.location.href = "/login?returnto="+returnTo;
            } else {
                alert(data.error || "Signup failed");
            }

        } catch (err) {
            console.error("Signup request failed:", err);
            alert("An error occurred. Please try again.");
        }
    });
}

const reportForm = document.getElementById("report-form");

if (reportForm) {
    const urlParams = new URLSearchParams(window.location.search);
    const organization = urlParams.get("organization") || "1"; // fallback to /

    reportForm.addEventListener("submit", async (e) => {
        e.preventDefault();

        const type = document.getElementById("type").value;
        const name = document.getElementById("name").value.trim();
        const description = document.getElementById("description").value.trim();
        const fileInput = document.getElementById("report-file-selector");
        const file = fileInput.files[0];

        if (!type || !name || !description) {
            alert("Please fill out all fields.");
            return;
        }

        let imageId = null;

        if (file) {
            try {
                const formData = new FormData();
                formData.append("file", file);

                const uploadResponse = await fetch("http://localhost:8080/api/upload", {
                    method: "POST",

                    body: formData,
                    credentials: "include"
                });

                if (!uploadResponse.ok) {
                    alert("Image upload failed.");
                    return;
                }

                const uploadData = await uploadResponse.json();
                imageId = uploadData.image_id;
            } catch (err) {
                console.error("Upload error:", err);
                alert("Image upload failed.");
                return;
            }
        }

        try {
            const body =
                "type=" + encodeURIComponent(type) +
                "&name=" + encodeURIComponent(name) +
                "&description=" + encodeURIComponent(description) +
                "&image_id=" + encodeURIComponent(imageId || "") +
                "&organization=" + encodeURIComponent(organization);

            const reportResponse = await fetch("http://localhost:8080/api/reports", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                credentials: "include",
                body: body
            });

            if (!reportResponse.ok) {
                const err = await reportResponse.json().catch(() => ({}));
                alert(err.error || "Report submission failed.");
                return;
            }

            const data = await reportResponse.json();

            if (data.success) {
                window.location.href = "/home"; // or wherever
            } else {
                alert(data.error || "Report submission failed.");
            }

        } catch (err) {
            console.error("Report error:", err);
            alert("Something went wrong.");
        }
    });
}

document.addEventListener("click", async function (e) {
    const btn = e.target.closest("button");
    if (!btn) return;

    // Make sure it's an approve button (optional: check class or parent)
    if (!btn.id.includes("_")) return;

    e.preventDefault(); // prevent default link behavior

    // Split the ID
    const [text, reportId] = btn.id.split("_");

    if (text != "item" || !reportId) {
        console.error("Invalid button ID format:", btn.id);
        return;
    }

    try {
        const response = await fetch("http://localhost:8080/api/reports/approve?id=" + encodeURIComponent(reportId), {
            method: "POST",
            credentials: "include",
        });

        if (!response.ok) {
            const err = await response.json().catch(() => ({}));
            alert(err.error || "Approval failed");
            return;
        }

        const data = await response.json();

        if (data.success) {
            alert("Report approved!");
            btn.closest("#itemcard")?.remove();
        } else {
            alert(data.error || "Approval failed");
        }

    } catch (err) {
        console.error("Approval request failed:", err);
        alert("An error occurred.");
    }
});