interface PlaceholderPageProps {
  title: string;
  description?: string;
}

export function PlaceholderPage({ title, description }: PlaceholderPageProps) {
  return (
    <section className="placeholder">
      <h2>{title}</h2>
      {description && <p>{description}</p>}
      <p className="hint">UI wiring will replace this placeholder as endpoints solidify.</p>
    </section>
  );
}
