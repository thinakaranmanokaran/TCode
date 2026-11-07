import { useEffect, useState } from "react";

export function LocalClock() {
  const [time, setTime] = useState("-- : -- : --");

  useEffect(() => {
    const format = () =>
      new Intl.DateTimeFormat("en-GB", {
        timeZone: "Asia/Kolkata",
        hour: "2-digit",
        minute: "2-digit",
        second: "2-digit",
        hour12: false,
      })
        .format(new Date())
        .split(":")
        .join(" : ");

    setTime(format());
    const timer = window.setInterval(() => setTime(format()), 1000);
    return () => window.clearInterval(timer);
  }, []);

  return (
    <span className="topbar__clock" aria-label={`Local time in India: ${time} IST`}>
      {time} <span>IST</span>
    </span>
  );
}
